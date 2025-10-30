package servlet;

import controller.CategoriesJpaController;
import controller.CoursesJpaController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Categories;
import model.Courses;
import model.Instructors;
import model.Users;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

@WebServlet(urlPatterns = {"/create-course"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class CreateCourseServlet extends HttpServlet {
    
    private EntityManagerFactory emf;
    private CoursesJpaController coursesController;
    private CategoriesJpaController categoriesController;
    
    private static final String UPLOAD_DIR = "uploads/course-thumbnails";
    
    @Override
    public void init() throws ServletException {
        try {
            emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
            coursesController = new CoursesJpaController(emf);
            categoriesController = new CategoriesJpaController(emf);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize EntityManagerFactory", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        if (!"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            // Load categories for dropdown
            List<Categories> categories = categoriesController.findCategoriesEntities();
            request.setAttribute("categories", categories);
            
            // Forward to create course JSP
            request.getRequestDispatcher("/create_course.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to load form data: " + e.getMessage());
            request.getRequestDispatcher("/create_course.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        if (!"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            // Get form parameters
            String title = request.getParameter("title");
            String intro = request.getParameter("intro");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price"); // Fixed: was "priceValue"
            String level = request.getParameter("level");
            String outcomes = request.getParameter("outcomes");
            String requirements = request.getParameter("requirements");
            String categoryId = request.getParameter("categoryId");
            
            // Debug log parameters
            System.out.println("=== FORM PARAMETERS ===");
            System.out.println("Title: " + title);
            System.out.println("Intro: " + (intro != null ? intro.substring(0, Math.min(50, intro.length())) : "null"));
            System.out.println("Price String: " + priceStr);
            System.out.println("Level: " + level);
            System.out.println("CategoryId: " + categoryId);
            System.out.println("======================");
            
            // Validate inputs
            if (title == null || title.trim().isEmpty() ||
                intro == null || intro.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                level == null || level.trim().isEmpty() ||
                outcomes == null || outcomes.trim().isEmpty() ||
                requirements == null || requirements.trim().isEmpty() ||
                categoryId == null || categoryId.trim().isEmpty()) {
                
                request.setAttribute("errorMsg", "All fields are required!");
                doGet(request, response);
                return;
            }
            
            // Parse price - remove comma separators first
            double price = 0;
            try {
                // Remove all commas and dots used as thousand separators
                String cleanPriceStr = priceStr.replaceAll("[,.]", "");
                price = Double.parseDouble(cleanPriceStr);
                System.out.println("Parsed price: " + price + " from string: " + priceStr);
            } catch (NumberFormatException e) {
                System.err.println("Failed to parse price: " + priceStr);
                request.setAttribute("errorMsg", "Invalid price format: " + priceStr);
                doGet(request, response);
                return;
            }
            
            // Handle file upload
            Part filePart = request.getPart("thumbnail");
            String fileName = null;
            String thumbUrl = null;
            
            if (filePart != null && filePart.getSize() > 0) {
                fileName = getFileName(filePart);
                
                // Generate unique filename
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                
                // Create upload directory if it doesn't exist
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Save file
                Path filePath = Paths.get(uploadPath, uniqueFileName);
                try (var inputStream = filePart.getInputStream()) {
                    Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                thumbUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
            } else {
                request.setAttribute("errorMsg", "Please upload a thumbnail image!");
                doGet(request, response);
                return;
            }
            
            // Load category entity
            Categories category = categoriesController.findCategories(categoryId);
            if (category == null) {
                request.setAttribute("errorMsg", "Invalid category selected!");
                doGet(request, response);
                return;
            }
            
            // Find or create instructor entity
            // We need instructor to be managed by a persistent EntityManager for the course creation
            Instructors instructor = null;
            
            // First, check if instructor exists
            EntityManager emCheck = emf.createEntityManager();
            try {
                instructor = emCheck.find(Instructors.class, user.getId());
                if (instructor == null) {
                    System.out.println("Instructor not found, creating new instructor record");
                    // Create basic instructor if not exists
                    Instructors newInstructor = new Instructors();
                    newInstructor.setId(user.getId());
                    newInstructor.setIntro("");
                    newInstructor.setExperience("");
                    newInstructor.setCreationTime(new Date());
                    newInstructor.setLastModificationTime(new Date());
                    newInstructor.setBalance(0L);
                    newInstructor.setCourseCount((short) 0);
                    newInstructor.setCreatorId(user);
                    
                    try {
                        emCheck.getTransaction().begin();
                        emCheck.persist(newInstructor);
                        emCheck.getTransaction().commit();
                        System.out.println("New instructor created with ID: " + newInstructor.getId());
                        instructor = newInstructor;
                    } catch (Exception createEx) {
                        if (emCheck.getTransaction().isActive()) {
                            emCheck.getTransaction().rollback();
                        }
                        // If duplicate key, instructor was created by another thread, reload it
                        if (createEx.getMessage() != null && createEx.getMessage().contains("duplicate key")) {
                            System.out.println("Instructor already exists (race condition), reloading...");
                            emCheck.clear();
                            instructor = emCheck.find(Instructors.class, user.getId());
                        } else {
                            throw createEx;
                        }
                    }
                } else {
                    System.out.println("Found existing instructor with ID: " + instructor.getId());
                }
            } catch (Exception e) {
                System.err.println("Fatal error handling instructor: " + e.getMessage());
                e.printStackTrace();
                emCheck.close();
                session.setAttribute("errorMsg", "Lỗi khi xử lý thông tin giảng viên: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/instructor-courses");
                return;
            } finally {
                emCheck.close();
            }
            
            // Verify instructor was loaded
            if (instructor == null) {
                System.err.println("ERROR: Instructor is null after loading!");
                session.setAttribute("errorMsg", "Không tìm thấy thông tin giảng viên");
                response.sendRedirect(request.getContextPath() + "/instructor-courses");
                return;
            }
            
            System.out.println("Instructor verified, ID: " + instructor.getId());
            
            // Create EntityManager for course creation
            EntityManager em = emf.createEntityManager();
            
            // Reload instructor in this EntityManager to make it managed
            instructor = em.find(Instructors.class, instructor.getId());
            if (instructor == null) {
                em.close();
                System.err.println("ERROR: Could not reload instructor in course EntityManager");
                session.setAttribute("errorMsg", "Lỗi khi tải thông tin giảng viên");
                response.sendRedirect(request.getContextPath() + "/instructor-courses");
                return;
            }
            
            // Create Course object
            Courses newCourse = new Courses();
            newCourse.setId(UUID.randomUUID().toString());
            newCourse.setTitle(title);
            newCourse.setMetaTitle(generateMetaTitle(title));
            newCourse.setThumbUrl(thumbUrl);
            newCourse.setIntro(intro);
            newCourse.setDescription(description);
            newCourse.setStatus("Draft"); // Default status
            newCourse.setPrice(price);
            newCourse.setDiscount(0.0);
            newCourse.setDiscountExpiry(new Date());
            newCourse.setLevel(level);
            newCourse.setOutcomes(outcomes);
            newCourse.setRequirements(requirements);
            newCourse.setLectureCount((short) 0);
            newCourse.setLearnerCount(0);
            newCourse.setRatingCount(0);
            newCourse.setTotalRating(0L);
            newCourse.setCreationTime(new Date());
            newCourse.setLastModificationTime(new Date());
            newCourse.setCreatorId(user);
            newCourse.setLastModifierId(user.getId());
            newCourse.setLeafCategoryId(category);
            newCourse.setInstructorId(instructor);
            
            // Save to database
            try {
                System.out.println("=== ATTEMPTING TO CREATE COURSE ===");
                System.out.println("Course ID: " + newCourse.getId());
                System.out.println("Course Title: " + newCourse.getTitle());
                System.out.println("Creator ID: " + user.getId());
                System.out.println("Creator Username: " + user.getUserName());
                System.out.println("Instructor ID: " + (instructor != null ? instructor.getId() : "NULL"));
                System.out.println("Category ID: " + (category != null ? category.getId() : "NULL"));
                System.out.println("Status: " + newCourse.getStatus());
                
                coursesController.create(newCourse);
                
                System.out.println("=== COURSE CREATED SUCCESSFULLY ===");
                System.out.println("Course will appear in manage courses page");
                
                // Redirect to instructor courses page with success message
                session.setAttribute("successMsg", "Khóa học đã được tạo thành công!");
                response.sendRedirect(request.getContextPath() + "/instructor-courses");
                
            } catch (Exception createEx) {
                System.err.println("=== ERROR CREATING COURSE ===");
                System.err.println("Error message: " + createEx.getMessage());
                System.err.println("Error class: " + createEx.getClass().getName());
                createEx.printStackTrace();
                
                // Set error message with details
                String errorDetail = createEx.getMessage() != null ? createEx.getMessage() : createEx.getClass().getSimpleName();
                session.setAttribute("errorMsg", "Lỗi khi tạo khóa học: " + errorDetail);
                response.sendRedirect(request.getContextPath() + "/instructor-courses");
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to create course: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private String generateMetaTitle(String title) {
        // Remove Vietnamese accents and convert to URL-friendly format
        return title.toLowerCase()
                    .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                    .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                    .replaceAll("[ìíịỉĩ]", "i")
                    .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                    .replaceAll("[ùúụủũưừứựửữ]", "u")
                    .replaceAll("[ỳýỵỷỹ]", "y")
                    .replaceAll("[đ]", "d")
                    .replaceAll("[^a-z0-9]+", "-")
                    .replaceAll("^-+|-+$", "");
    }
    
    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
