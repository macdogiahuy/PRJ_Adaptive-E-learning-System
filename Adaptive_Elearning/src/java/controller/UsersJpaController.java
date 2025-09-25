/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Instructors;
import model.Articles;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Assignments;
import model.CourseReviews;
import model.Courses;
import model.Conversations;
import model.Enrollments;
import model.Comments;
import model.ChatMessages;
import model.ConversationMembers;
import model.Notifications;
import model.Submissions;
import model.Bills;
import model.Users;

/**
 *
 * @author LP
 */
public class UsersJpaController implements Serializable {

    public UsersJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Users users) throws PreexistingEntityException, Exception {
        if (users.getArticlesList() == null) {
            users.setArticlesList(new ArrayList<Articles>());
        }
        if (users.getAssignmentsList() == null) {
            users.setAssignmentsList(new ArrayList<Assignments>());
        }
        if (users.getCourseReviewsList() == null) {
            users.setCourseReviewsList(new ArrayList<CourseReviews>());
        }
        if (users.getCoursesList() == null) {
            users.setCoursesList(new ArrayList<Courses>());
        }
        if (users.getConversationsList() == null) {
            users.setConversationsList(new ArrayList<Conversations>());
        }
        if (users.getEnrollmentsList() == null) {
            users.setEnrollmentsList(new ArrayList<Enrollments>());
        }
        if (users.getCommentsList() == null) {
            users.setCommentsList(new ArrayList<Comments>());
        }
        if (users.getChatMessagesList() == null) {
            users.setChatMessagesList(new ArrayList<ChatMessages>());
        }
        if (users.getConversationMembersList() == null) {
            users.setConversationMembersList(new ArrayList<ConversationMembers>());
        }
        if (users.getNotificationsList() == null) {
            users.setNotificationsList(new ArrayList<Notifications>());
        }
        if (users.getNotificationsList1() == null) {
            users.setNotificationsList1(new ArrayList<Notifications>());
        }
        if (users.getSubmissionsList() == null) {
            users.setSubmissionsList(new ArrayList<Submissions>());
        }
        if (users.getBillsList() == null) {
            users.setBillsList(new ArrayList<Bills>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Instructors instructors = users.getInstructors();
            if (instructors != null) {
                instructors = em.getReference(instructors.getClass(), instructors.getId());
                users.setInstructors(instructors);
            }
            List<Articles> attachedArticlesList = new ArrayList<Articles>();
            for (Articles articlesListArticlesToAttach : users.getArticlesList()) {
                articlesListArticlesToAttach = em.getReference(articlesListArticlesToAttach.getClass(), articlesListArticlesToAttach.getId());
                attachedArticlesList.add(articlesListArticlesToAttach);
            }
            users.setArticlesList(attachedArticlesList);
            List<Assignments> attachedAssignmentsList = new ArrayList<Assignments>();
            for (Assignments assignmentsListAssignmentsToAttach : users.getAssignmentsList()) {
                assignmentsListAssignmentsToAttach = em.getReference(assignmentsListAssignmentsToAttach.getClass(), assignmentsListAssignmentsToAttach.getId());
                attachedAssignmentsList.add(assignmentsListAssignmentsToAttach);
            }
            users.setAssignmentsList(attachedAssignmentsList);
            List<CourseReviews> attachedCourseReviewsList = new ArrayList<CourseReviews>();
            for (CourseReviews courseReviewsListCourseReviewsToAttach : users.getCourseReviewsList()) {
                courseReviewsListCourseReviewsToAttach = em.getReference(courseReviewsListCourseReviewsToAttach.getClass(), courseReviewsListCourseReviewsToAttach.getId());
                attachedCourseReviewsList.add(courseReviewsListCourseReviewsToAttach);
            }
            users.setCourseReviewsList(attachedCourseReviewsList);
            List<Courses> attachedCoursesList = new ArrayList<Courses>();
            for (Courses coursesListCoursesToAttach : users.getCoursesList()) {
                coursesListCoursesToAttach = em.getReference(coursesListCoursesToAttach.getClass(), coursesListCoursesToAttach.getId());
                attachedCoursesList.add(coursesListCoursesToAttach);
            }
            users.setCoursesList(attachedCoursesList);
            List<Conversations> attachedConversationsList = new ArrayList<Conversations>();
            for (Conversations conversationsListConversationsToAttach : users.getConversationsList()) {
                conversationsListConversationsToAttach = em.getReference(conversationsListConversationsToAttach.getClass(), conversationsListConversationsToAttach.getId());
                attachedConversationsList.add(conversationsListConversationsToAttach);
            }
            users.setConversationsList(attachedConversationsList);
            List<Enrollments> attachedEnrollmentsList = new ArrayList<Enrollments>();
            for (Enrollments enrollmentsListEnrollmentsToAttach : users.getEnrollmentsList()) {
                enrollmentsListEnrollmentsToAttach = em.getReference(enrollmentsListEnrollmentsToAttach.getClass(), enrollmentsListEnrollmentsToAttach.getEnrollmentsPK());
                attachedEnrollmentsList.add(enrollmentsListEnrollmentsToAttach);
            }
            users.setEnrollmentsList(attachedEnrollmentsList);
            List<Comments> attachedCommentsList = new ArrayList<Comments>();
            for (Comments commentsListCommentsToAttach : users.getCommentsList()) {
                commentsListCommentsToAttach = em.getReference(commentsListCommentsToAttach.getClass(), commentsListCommentsToAttach.getId());
                attachedCommentsList.add(commentsListCommentsToAttach);
            }
            users.setCommentsList(attachedCommentsList);
            List<ChatMessages> attachedChatMessagesList = new ArrayList<ChatMessages>();
            for (ChatMessages chatMessagesListChatMessagesToAttach : users.getChatMessagesList()) {
                chatMessagesListChatMessagesToAttach = em.getReference(chatMessagesListChatMessagesToAttach.getClass(), chatMessagesListChatMessagesToAttach.getId());
                attachedChatMessagesList.add(chatMessagesListChatMessagesToAttach);
            }
            users.setChatMessagesList(attachedChatMessagesList);
            List<ConversationMembers> attachedConversationMembersList = new ArrayList<ConversationMembers>();
            for (ConversationMembers conversationMembersListConversationMembersToAttach : users.getConversationMembersList()) {
                conversationMembersListConversationMembersToAttach = em.getReference(conversationMembersListConversationMembersToAttach.getClass(), conversationMembersListConversationMembersToAttach.getConversationMembersPK());
                attachedConversationMembersList.add(conversationMembersListConversationMembersToAttach);
            }
            users.setConversationMembersList(attachedConversationMembersList);
            List<Notifications> attachedNotificationsList = new ArrayList<Notifications>();
            for (Notifications notificationsListNotificationsToAttach : users.getNotificationsList()) {
                notificationsListNotificationsToAttach = em.getReference(notificationsListNotificationsToAttach.getClass(), notificationsListNotificationsToAttach.getId());
                attachedNotificationsList.add(notificationsListNotificationsToAttach);
            }
            users.setNotificationsList(attachedNotificationsList);
            List<Notifications> attachedNotificationsList1 = new ArrayList<Notifications>();
            for (Notifications notificationsList1NotificationsToAttach : users.getNotificationsList1()) {
                notificationsList1NotificationsToAttach = em.getReference(notificationsList1NotificationsToAttach.getClass(), notificationsList1NotificationsToAttach.getId());
                attachedNotificationsList1.add(notificationsList1NotificationsToAttach);
            }
            users.setNotificationsList1(attachedNotificationsList1);
            List<Submissions> attachedSubmissionsList = new ArrayList<Submissions>();
            for (Submissions submissionsListSubmissionsToAttach : users.getSubmissionsList()) {
                submissionsListSubmissionsToAttach = em.getReference(submissionsListSubmissionsToAttach.getClass(), submissionsListSubmissionsToAttach.getId());
                attachedSubmissionsList.add(submissionsListSubmissionsToAttach);
            }
            users.setSubmissionsList(attachedSubmissionsList);
            List<Bills> attachedBillsList = new ArrayList<Bills>();
            for (Bills billsListBillsToAttach : users.getBillsList()) {
                billsListBillsToAttach = em.getReference(billsListBillsToAttach.getClass(), billsListBillsToAttach.getId());
                attachedBillsList.add(billsListBillsToAttach);
            }
            users.setBillsList(attachedBillsList);
            em.persist(users);
            if (instructors != null) {
                Users oldCreatorIdOfInstructors = instructors.getCreatorId();
                if (oldCreatorIdOfInstructors != null) {
                    oldCreatorIdOfInstructors.setInstructors(null);
                    oldCreatorIdOfInstructors = em.merge(oldCreatorIdOfInstructors);
                }
                instructors.setCreatorId(users);
                instructors = em.merge(instructors);
            }
            for (Articles articlesListArticles : users.getArticlesList()) {
                Users oldCreatorIdOfArticlesListArticles = articlesListArticles.getCreatorId();
                articlesListArticles.setCreatorId(users);
                articlesListArticles = em.merge(articlesListArticles);
                if (oldCreatorIdOfArticlesListArticles != null) {
                    oldCreatorIdOfArticlesListArticles.getArticlesList().remove(articlesListArticles);
                    oldCreatorIdOfArticlesListArticles = em.merge(oldCreatorIdOfArticlesListArticles);
                }
            }
            for (Assignments assignmentsListAssignments : users.getAssignmentsList()) {
                Users oldCreatorIdOfAssignmentsListAssignments = assignmentsListAssignments.getCreatorId();
                assignmentsListAssignments.setCreatorId(users);
                assignmentsListAssignments = em.merge(assignmentsListAssignments);
                if (oldCreatorIdOfAssignmentsListAssignments != null) {
                    oldCreatorIdOfAssignmentsListAssignments.getAssignmentsList().remove(assignmentsListAssignments);
                    oldCreatorIdOfAssignmentsListAssignments = em.merge(oldCreatorIdOfAssignmentsListAssignments);
                }
            }
            for (CourseReviews courseReviewsListCourseReviews : users.getCourseReviewsList()) {
                Users oldCreatorIdOfCourseReviewsListCourseReviews = courseReviewsListCourseReviews.getCreatorId();
                courseReviewsListCourseReviews.setCreatorId(users);
                courseReviewsListCourseReviews = em.merge(courseReviewsListCourseReviews);
                if (oldCreatorIdOfCourseReviewsListCourseReviews != null) {
                    oldCreatorIdOfCourseReviewsListCourseReviews.getCourseReviewsList().remove(courseReviewsListCourseReviews);
                    oldCreatorIdOfCourseReviewsListCourseReviews = em.merge(oldCreatorIdOfCourseReviewsListCourseReviews);
                }
            }
            for (Courses coursesListCourses : users.getCoursesList()) {
                Users oldCreatorIdOfCoursesListCourses = coursesListCourses.getCreatorId();
                coursesListCourses.setCreatorId(users);
                coursesListCourses = em.merge(coursesListCourses);
                if (oldCreatorIdOfCoursesListCourses != null) {
                    oldCreatorIdOfCoursesListCourses.getCoursesList().remove(coursesListCourses);
                    oldCreatorIdOfCoursesListCourses = em.merge(oldCreatorIdOfCoursesListCourses);
                }
            }
            for (Conversations conversationsListConversations : users.getConversationsList()) {
                Users oldCreatorIdOfConversationsListConversations = conversationsListConversations.getCreatorId();
                conversationsListConversations.setCreatorId(users);
                conversationsListConversations = em.merge(conversationsListConversations);
                if (oldCreatorIdOfConversationsListConversations != null) {
                    oldCreatorIdOfConversationsListConversations.getConversationsList().remove(conversationsListConversations);
                    oldCreatorIdOfConversationsListConversations = em.merge(oldCreatorIdOfConversationsListConversations);
                }
            }
            for (Enrollments enrollmentsListEnrollments : users.getEnrollmentsList()) {
                Users oldUsersOfEnrollmentsListEnrollments = enrollmentsListEnrollments.getUsers();
                enrollmentsListEnrollments.setUsers(users);
                enrollmentsListEnrollments = em.merge(enrollmentsListEnrollments);
                if (oldUsersOfEnrollmentsListEnrollments != null) {
                    oldUsersOfEnrollmentsListEnrollments.getEnrollmentsList().remove(enrollmentsListEnrollments);
                    oldUsersOfEnrollmentsListEnrollments = em.merge(oldUsersOfEnrollmentsListEnrollments);
                }
            }
            for (Comments commentsListComments : users.getCommentsList()) {
                Users oldCreatorIdOfCommentsListComments = commentsListComments.getCreatorId();
                commentsListComments.setCreatorId(users);
                commentsListComments = em.merge(commentsListComments);
                if (oldCreatorIdOfCommentsListComments != null) {
                    oldCreatorIdOfCommentsListComments.getCommentsList().remove(commentsListComments);
                    oldCreatorIdOfCommentsListComments = em.merge(oldCreatorIdOfCommentsListComments);
                }
            }
            for (ChatMessages chatMessagesListChatMessages : users.getChatMessagesList()) {
                Users oldCreatorIdOfChatMessagesListChatMessages = chatMessagesListChatMessages.getCreatorId();
                chatMessagesListChatMessages.setCreatorId(users);
                chatMessagesListChatMessages = em.merge(chatMessagesListChatMessages);
                if (oldCreatorIdOfChatMessagesListChatMessages != null) {
                    oldCreatorIdOfChatMessagesListChatMessages.getChatMessagesList().remove(chatMessagesListChatMessages);
                    oldCreatorIdOfChatMessagesListChatMessages = em.merge(oldCreatorIdOfChatMessagesListChatMessages);
                }
            }
            for (ConversationMembers conversationMembersListConversationMembers : users.getConversationMembersList()) {
                Users oldUsersOfConversationMembersListConversationMembers = conversationMembersListConversationMembers.getUsers();
                conversationMembersListConversationMembers.setUsers(users);
                conversationMembersListConversationMembers = em.merge(conversationMembersListConversationMembers);
                if (oldUsersOfConversationMembersListConversationMembers != null) {
                    oldUsersOfConversationMembersListConversationMembers.getConversationMembersList().remove(conversationMembersListConversationMembers);
                    oldUsersOfConversationMembersListConversationMembers = em.merge(oldUsersOfConversationMembersListConversationMembers);
                }
            }
            for (Notifications notificationsListNotifications : users.getNotificationsList()) {
                Users oldCreatorIdOfNotificationsListNotifications = notificationsListNotifications.getCreatorId();
                notificationsListNotifications.setCreatorId(users);
                notificationsListNotifications = em.merge(notificationsListNotifications);
                if (oldCreatorIdOfNotificationsListNotifications != null) {
                    oldCreatorIdOfNotificationsListNotifications.getNotificationsList().remove(notificationsListNotifications);
                    oldCreatorIdOfNotificationsListNotifications = em.merge(oldCreatorIdOfNotificationsListNotifications);
                }
            }
            for (Notifications notificationsList1Notifications : users.getNotificationsList1()) {
                Users oldReceiverIdOfNotificationsList1Notifications = notificationsList1Notifications.getReceiverId();
                notificationsList1Notifications.setReceiverId(users);
                notificationsList1Notifications = em.merge(notificationsList1Notifications);
                if (oldReceiverIdOfNotificationsList1Notifications != null) {
                    oldReceiverIdOfNotificationsList1Notifications.getNotificationsList1().remove(notificationsList1Notifications);
                    oldReceiverIdOfNotificationsList1Notifications = em.merge(oldReceiverIdOfNotificationsList1Notifications);
                }
            }
            for (Submissions submissionsListSubmissions : users.getSubmissionsList()) {
                Users oldCreatorIdOfSubmissionsListSubmissions = submissionsListSubmissions.getCreatorId();
                submissionsListSubmissions.setCreatorId(users);
                submissionsListSubmissions = em.merge(submissionsListSubmissions);
                if (oldCreatorIdOfSubmissionsListSubmissions != null) {
                    oldCreatorIdOfSubmissionsListSubmissions.getSubmissionsList().remove(submissionsListSubmissions);
                    oldCreatorIdOfSubmissionsListSubmissions = em.merge(oldCreatorIdOfSubmissionsListSubmissions);
                }
            }
            for (Bills billsListBills : users.getBillsList()) {
                Users oldCreatorIdOfBillsListBills = billsListBills.getCreatorId();
                billsListBills.setCreatorId(users);
                billsListBills = em.merge(billsListBills);
                if (oldCreatorIdOfBillsListBills != null) {
                    oldCreatorIdOfBillsListBills.getBillsList().remove(billsListBills);
                    oldCreatorIdOfBillsListBills = em.merge(oldCreatorIdOfBillsListBills);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findUsers(users.getId()) != null) {
                throw new PreexistingEntityException("Users " + users + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Users users) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users persistentUsers = em.find(Users.class, users.getId());
            Instructors instructorsOld = persistentUsers.getInstructors();
            Instructors instructorsNew = users.getInstructors();
            List<Articles> articlesListOld = persistentUsers.getArticlesList();
            List<Articles> articlesListNew = users.getArticlesList();
            List<Assignments> assignmentsListOld = persistentUsers.getAssignmentsList();
            List<Assignments> assignmentsListNew = users.getAssignmentsList();
            List<CourseReviews> courseReviewsListOld = persistentUsers.getCourseReviewsList();
            List<CourseReviews> courseReviewsListNew = users.getCourseReviewsList();
            List<Courses> coursesListOld = persistentUsers.getCoursesList();
            List<Courses> coursesListNew = users.getCoursesList();
            List<Conversations> conversationsListOld = persistentUsers.getConversationsList();
            List<Conversations> conversationsListNew = users.getConversationsList();
            List<Enrollments> enrollmentsListOld = persistentUsers.getEnrollmentsList();
            List<Enrollments> enrollmentsListNew = users.getEnrollmentsList();
            List<Comments> commentsListOld = persistentUsers.getCommentsList();
            List<Comments> commentsListNew = users.getCommentsList();
            List<ChatMessages> chatMessagesListOld = persistentUsers.getChatMessagesList();
            List<ChatMessages> chatMessagesListNew = users.getChatMessagesList();
            List<ConversationMembers> conversationMembersListOld = persistentUsers.getConversationMembersList();
            List<ConversationMembers> conversationMembersListNew = users.getConversationMembersList();
            List<Notifications> notificationsListOld = persistentUsers.getNotificationsList();
            List<Notifications> notificationsListNew = users.getNotificationsList();
            List<Notifications> notificationsList1Old = persistentUsers.getNotificationsList1();
            List<Notifications> notificationsList1New = users.getNotificationsList1();
            List<Submissions> submissionsListOld = persistentUsers.getSubmissionsList();
            List<Submissions> submissionsListNew = users.getSubmissionsList();
            List<Bills> billsListOld = persistentUsers.getBillsList();
            List<Bills> billsListNew = users.getBillsList();
            List<String> illegalOrphanMessages = null;
            if (instructorsOld != null && !instructorsOld.equals(instructorsNew)) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("You must retain Instructors " + instructorsOld + " since its creatorId field is not nullable.");
            }
            for (Articles articlesListOldArticles : articlesListOld) {
                if (!articlesListNew.contains(articlesListOldArticles)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Articles " + articlesListOldArticles + " since its creatorId field is not nullable.");
                }
            }
            for (Assignments assignmentsListOldAssignments : assignmentsListOld) {
                if (!assignmentsListNew.contains(assignmentsListOldAssignments)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Assignments " + assignmentsListOldAssignments + " since its creatorId field is not nullable.");
                }
            }
            for (CourseReviews courseReviewsListOldCourseReviews : courseReviewsListOld) {
                if (!courseReviewsListNew.contains(courseReviewsListOldCourseReviews)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain CourseReviews " + courseReviewsListOldCourseReviews + " since its creatorId field is not nullable.");
                }
            }
            for (Courses coursesListOldCourses : coursesListOld) {
                if (!coursesListNew.contains(coursesListOldCourses)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Courses " + coursesListOldCourses + " since its creatorId field is not nullable.");
                }
            }
            for (Conversations conversationsListOldConversations : conversationsListOld) {
                if (!conversationsListNew.contains(conversationsListOldConversations)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Conversations " + conversationsListOldConversations + " since its creatorId field is not nullable.");
                }
            }
            for (Enrollments enrollmentsListOldEnrollments : enrollmentsListOld) {
                if (!enrollmentsListNew.contains(enrollmentsListOldEnrollments)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Enrollments " + enrollmentsListOldEnrollments + " since its users field is not nullable.");
                }
            }
            for (Comments commentsListOldComments : commentsListOld) {
                if (!commentsListNew.contains(commentsListOldComments)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Comments " + commentsListOldComments + " since its creatorId field is not nullable.");
                }
            }
            for (ChatMessages chatMessagesListOldChatMessages : chatMessagesListOld) {
                if (!chatMessagesListNew.contains(chatMessagesListOldChatMessages)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain ChatMessages " + chatMessagesListOldChatMessages + " since its creatorId field is not nullable.");
                }
            }
            for (ConversationMembers conversationMembersListOldConversationMembers : conversationMembersListOld) {
                if (!conversationMembersListNew.contains(conversationMembersListOldConversationMembers)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain ConversationMembers " + conversationMembersListOldConversationMembers + " since its users field is not nullable.");
                }
            }
            for (Notifications notificationsListOldNotifications : notificationsListOld) {
                if (!notificationsListNew.contains(notificationsListOldNotifications)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Notifications " + notificationsListOldNotifications + " since its creatorId field is not nullable.");
                }
            }
            for (Submissions submissionsListOldSubmissions : submissionsListOld) {
                if (!submissionsListNew.contains(submissionsListOldSubmissions)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Submissions " + submissionsListOldSubmissions + " since its creatorId field is not nullable.");
                }
            }
            for (Bills billsListOldBills : billsListOld) {
                if (!billsListNew.contains(billsListOldBills)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Bills " + billsListOldBills + " since its creatorId field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (instructorsNew != null) {
                instructorsNew = em.getReference(instructorsNew.getClass(), instructorsNew.getId());
                users.setInstructors(instructorsNew);
            }
            List<Articles> attachedArticlesListNew = new ArrayList<Articles>();
            for (Articles articlesListNewArticlesToAttach : articlesListNew) {
                articlesListNewArticlesToAttach = em.getReference(articlesListNewArticlesToAttach.getClass(), articlesListNewArticlesToAttach.getId());
                attachedArticlesListNew.add(articlesListNewArticlesToAttach);
            }
            articlesListNew = attachedArticlesListNew;
            users.setArticlesList(articlesListNew);
            List<Assignments> attachedAssignmentsListNew = new ArrayList<Assignments>();
            for (Assignments assignmentsListNewAssignmentsToAttach : assignmentsListNew) {
                assignmentsListNewAssignmentsToAttach = em.getReference(assignmentsListNewAssignmentsToAttach.getClass(), assignmentsListNewAssignmentsToAttach.getId());
                attachedAssignmentsListNew.add(assignmentsListNewAssignmentsToAttach);
            }
            assignmentsListNew = attachedAssignmentsListNew;
            users.setAssignmentsList(assignmentsListNew);
            List<CourseReviews> attachedCourseReviewsListNew = new ArrayList<CourseReviews>();
            for (CourseReviews courseReviewsListNewCourseReviewsToAttach : courseReviewsListNew) {
                courseReviewsListNewCourseReviewsToAttach = em.getReference(courseReviewsListNewCourseReviewsToAttach.getClass(), courseReviewsListNewCourseReviewsToAttach.getId());
                attachedCourseReviewsListNew.add(courseReviewsListNewCourseReviewsToAttach);
            }
            courseReviewsListNew = attachedCourseReviewsListNew;
            users.setCourseReviewsList(courseReviewsListNew);
            List<Courses> attachedCoursesListNew = new ArrayList<Courses>();
            for (Courses coursesListNewCoursesToAttach : coursesListNew) {
                coursesListNewCoursesToAttach = em.getReference(coursesListNewCoursesToAttach.getClass(), coursesListNewCoursesToAttach.getId());
                attachedCoursesListNew.add(coursesListNewCoursesToAttach);
            }
            coursesListNew = attachedCoursesListNew;
            users.setCoursesList(coursesListNew);
            List<Conversations> attachedConversationsListNew = new ArrayList<Conversations>();
            for (Conversations conversationsListNewConversationsToAttach : conversationsListNew) {
                conversationsListNewConversationsToAttach = em.getReference(conversationsListNewConversationsToAttach.getClass(), conversationsListNewConversationsToAttach.getId());
                attachedConversationsListNew.add(conversationsListNewConversationsToAttach);
            }
            conversationsListNew = attachedConversationsListNew;
            users.setConversationsList(conversationsListNew);
            List<Enrollments> attachedEnrollmentsListNew = new ArrayList<Enrollments>();
            for (Enrollments enrollmentsListNewEnrollmentsToAttach : enrollmentsListNew) {
                enrollmentsListNewEnrollmentsToAttach = em.getReference(enrollmentsListNewEnrollmentsToAttach.getClass(), enrollmentsListNewEnrollmentsToAttach.getEnrollmentsPK());
                attachedEnrollmentsListNew.add(enrollmentsListNewEnrollmentsToAttach);
            }
            enrollmentsListNew = attachedEnrollmentsListNew;
            users.setEnrollmentsList(enrollmentsListNew);
            List<Comments> attachedCommentsListNew = new ArrayList<Comments>();
            for (Comments commentsListNewCommentsToAttach : commentsListNew) {
                commentsListNewCommentsToAttach = em.getReference(commentsListNewCommentsToAttach.getClass(), commentsListNewCommentsToAttach.getId());
                attachedCommentsListNew.add(commentsListNewCommentsToAttach);
            }
            commentsListNew = attachedCommentsListNew;
            users.setCommentsList(commentsListNew);
            List<ChatMessages> attachedChatMessagesListNew = new ArrayList<ChatMessages>();
            for (ChatMessages chatMessagesListNewChatMessagesToAttach : chatMessagesListNew) {
                chatMessagesListNewChatMessagesToAttach = em.getReference(chatMessagesListNewChatMessagesToAttach.getClass(), chatMessagesListNewChatMessagesToAttach.getId());
                attachedChatMessagesListNew.add(chatMessagesListNewChatMessagesToAttach);
            }
            chatMessagesListNew = attachedChatMessagesListNew;
            users.setChatMessagesList(chatMessagesListNew);
            List<ConversationMembers> attachedConversationMembersListNew = new ArrayList<ConversationMembers>();
            for (ConversationMembers conversationMembersListNewConversationMembersToAttach : conversationMembersListNew) {
                conversationMembersListNewConversationMembersToAttach = em.getReference(conversationMembersListNewConversationMembersToAttach.getClass(), conversationMembersListNewConversationMembersToAttach.getConversationMembersPK());
                attachedConversationMembersListNew.add(conversationMembersListNewConversationMembersToAttach);
            }
            conversationMembersListNew = attachedConversationMembersListNew;
            users.setConversationMembersList(conversationMembersListNew);
            List<Notifications> attachedNotificationsListNew = new ArrayList<Notifications>();
            for (Notifications notificationsListNewNotificationsToAttach : notificationsListNew) {
                notificationsListNewNotificationsToAttach = em.getReference(notificationsListNewNotificationsToAttach.getClass(), notificationsListNewNotificationsToAttach.getId());
                attachedNotificationsListNew.add(notificationsListNewNotificationsToAttach);
            }
            notificationsListNew = attachedNotificationsListNew;
            users.setNotificationsList(notificationsListNew);
            List<Notifications> attachedNotificationsList1New = new ArrayList<Notifications>();
            for (Notifications notificationsList1NewNotificationsToAttach : notificationsList1New) {
                notificationsList1NewNotificationsToAttach = em.getReference(notificationsList1NewNotificationsToAttach.getClass(), notificationsList1NewNotificationsToAttach.getId());
                attachedNotificationsList1New.add(notificationsList1NewNotificationsToAttach);
            }
            notificationsList1New = attachedNotificationsList1New;
            users.setNotificationsList1(notificationsList1New);
            List<Submissions> attachedSubmissionsListNew = new ArrayList<Submissions>();
            for (Submissions submissionsListNewSubmissionsToAttach : submissionsListNew) {
                submissionsListNewSubmissionsToAttach = em.getReference(submissionsListNewSubmissionsToAttach.getClass(), submissionsListNewSubmissionsToAttach.getId());
                attachedSubmissionsListNew.add(submissionsListNewSubmissionsToAttach);
            }
            submissionsListNew = attachedSubmissionsListNew;
            users.setSubmissionsList(submissionsListNew);
            List<Bills> attachedBillsListNew = new ArrayList<Bills>();
            for (Bills billsListNewBillsToAttach : billsListNew) {
                billsListNewBillsToAttach = em.getReference(billsListNewBillsToAttach.getClass(), billsListNewBillsToAttach.getId());
                attachedBillsListNew.add(billsListNewBillsToAttach);
            }
            billsListNew = attachedBillsListNew;
            users.setBillsList(billsListNew);
            users = em.merge(users);
            if (instructorsNew != null && !instructorsNew.equals(instructorsOld)) {
                Users oldCreatorIdOfInstructors = instructorsNew.getCreatorId();
                if (oldCreatorIdOfInstructors != null) {
                    oldCreatorIdOfInstructors.setInstructors(null);
                    oldCreatorIdOfInstructors = em.merge(oldCreatorIdOfInstructors);
                }
                instructorsNew.setCreatorId(users);
                instructorsNew = em.merge(instructorsNew);
            }
            for (Articles articlesListNewArticles : articlesListNew) {
                if (!articlesListOld.contains(articlesListNewArticles)) {
                    Users oldCreatorIdOfArticlesListNewArticles = articlesListNewArticles.getCreatorId();
                    articlesListNewArticles.setCreatorId(users);
                    articlesListNewArticles = em.merge(articlesListNewArticles);
                    if (oldCreatorIdOfArticlesListNewArticles != null && !oldCreatorIdOfArticlesListNewArticles.equals(users)) {
                        oldCreatorIdOfArticlesListNewArticles.getArticlesList().remove(articlesListNewArticles);
                        oldCreatorIdOfArticlesListNewArticles = em.merge(oldCreatorIdOfArticlesListNewArticles);
                    }
                }
            }
            for (Assignments assignmentsListNewAssignments : assignmentsListNew) {
                if (!assignmentsListOld.contains(assignmentsListNewAssignments)) {
                    Users oldCreatorIdOfAssignmentsListNewAssignments = assignmentsListNewAssignments.getCreatorId();
                    assignmentsListNewAssignments.setCreatorId(users);
                    assignmentsListNewAssignments = em.merge(assignmentsListNewAssignments);
                    if (oldCreatorIdOfAssignmentsListNewAssignments != null && !oldCreatorIdOfAssignmentsListNewAssignments.equals(users)) {
                        oldCreatorIdOfAssignmentsListNewAssignments.getAssignmentsList().remove(assignmentsListNewAssignments);
                        oldCreatorIdOfAssignmentsListNewAssignments = em.merge(oldCreatorIdOfAssignmentsListNewAssignments);
                    }
                }
            }
            for (CourseReviews courseReviewsListNewCourseReviews : courseReviewsListNew) {
                if (!courseReviewsListOld.contains(courseReviewsListNewCourseReviews)) {
                    Users oldCreatorIdOfCourseReviewsListNewCourseReviews = courseReviewsListNewCourseReviews.getCreatorId();
                    courseReviewsListNewCourseReviews.setCreatorId(users);
                    courseReviewsListNewCourseReviews = em.merge(courseReviewsListNewCourseReviews);
                    if (oldCreatorIdOfCourseReviewsListNewCourseReviews != null && !oldCreatorIdOfCourseReviewsListNewCourseReviews.equals(users)) {
                        oldCreatorIdOfCourseReviewsListNewCourseReviews.getCourseReviewsList().remove(courseReviewsListNewCourseReviews);
                        oldCreatorIdOfCourseReviewsListNewCourseReviews = em.merge(oldCreatorIdOfCourseReviewsListNewCourseReviews);
                    }
                }
            }
            for (Courses coursesListNewCourses : coursesListNew) {
                if (!coursesListOld.contains(coursesListNewCourses)) {
                    Users oldCreatorIdOfCoursesListNewCourses = coursesListNewCourses.getCreatorId();
                    coursesListNewCourses.setCreatorId(users);
                    coursesListNewCourses = em.merge(coursesListNewCourses);
                    if (oldCreatorIdOfCoursesListNewCourses != null && !oldCreatorIdOfCoursesListNewCourses.equals(users)) {
                        oldCreatorIdOfCoursesListNewCourses.getCoursesList().remove(coursesListNewCourses);
                        oldCreatorIdOfCoursesListNewCourses = em.merge(oldCreatorIdOfCoursesListNewCourses);
                    }
                }
            }
            for (Conversations conversationsListNewConversations : conversationsListNew) {
                if (!conversationsListOld.contains(conversationsListNewConversations)) {
                    Users oldCreatorIdOfConversationsListNewConversations = conversationsListNewConversations.getCreatorId();
                    conversationsListNewConversations.setCreatorId(users);
                    conversationsListNewConversations = em.merge(conversationsListNewConversations);
                    if (oldCreatorIdOfConversationsListNewConversations != null && !oldCreatorIdOfConversationsListNewConversations.equals(users)) {
                        oldCreatorIdOfConversationsListNewConversations.getConversationsList().remove(conversationsListNewConversations);
                        oldCreatorIdOfConversationsListNewConversations = em.merge(oldCreatorIdOfConversationsListNewConversations);
                    }
                }
            }
            for (Enrollments enrollmentsListNewEnrollments : enrollmentsListNew) {
                if (!enrollmentsListOld.contains(enrollmentsListNewEnrollments)) {
                    Users oldUsersOfEnrollmentsListNewEnrollments = enrollmentsListNewEnrollments.getUsers();
                    enrollmentsListNewEnrollments.setUsers(users);
                    enrollmentsListNewEnrollments = em.merge(enrollmentsListNewEnrollments);
                    if (oldUsersOfEnrollmentsListNewEnrollments != null && !oldUsersOfEnrollmentsListNewEnrollments.equals(users)) {
                        oldUsersOfEnrollmentsListNewEnrollments.getEnrollmentsList().remove(enrollmentsListNewEnrollments);
                        oldUsersOfEnrollmentsListNewEnrollments = em.merge(oldUsersOfEnrollmentsListNewEnrollments);
                    }
                }
            }
            for (Comments commentsListNewComments : commentsListNew) {
                if (!commentsListOld.contains(commentsListNewComments)) {
                    Users oldCreatorIdOfCommentsListNewComments = commentsListNewComments.getCreatorId();
                    commentsListNewComments.setCreatorId(users);
                    commentsListNewComments = em.merge(commentsListNewComments);
                    if (oldCreatorIdOfCommentsListNewComments != null && !oldCreatorIdOfCommentsListNewComments.equals(users)) {
                        oldCreatorIdOfCommentsListNewComments.getCommentsList().remove(commentsListNewComments);
                        oldCreatorIdOfCommentsListNewComments = em.merge(oldCreatorIdOfCommentsListNewComments);
                    }
                }
            }
            for (ChatMessages chatMessagesListNewChatMessages : chatMessagesListNew) {
                if (!chatMessagesListOld.contains(chatMessagesListNewChatMessages)) {
                    Users oldCreatorIdOfChatMessagesListNewChatMessages = chatMessagesListNewChatMessages.getCreatorId();
                    chatMessagesListNewChatMessages.setCreatorId(users);
                    chatMessagesListNewChatMessages = em.merge(chatMessagesListNewChatMessages);
                    if (oldCreatorIdOfChatMessagesListNewChatMessages != null && !oldCreatorIdOfChatMessagesListNewChatMessages.equals(users)) {
                        oldCreatorIdOfChatMessagesListNewChatMessages.getChatMessagesList().remove(chatMessagesListNewChatMessages);
                        oldCreatorIdOfChatMessagesListNewChatMessages = em.merge(oldCreatorIdOfChatMessagesListNewChatMessages);
                    }
                }
            }
            for (ConversationMembers conversationMembersListNewConversationMembers : conversationMembersListNew) {
                if (!conversationMembersListOld.contains(conversationMembersListNewConversationMembers)) {
                    Users oldUsersOfConversationMembersListNewConversationMembers = conversationMembersListNewConversationMembers.getUsers();
                    conversationMembersListNewConversationMembers.setUsers(users);
                    conversationMembersListNewConversationMembers = em.merge(conversationMembersListNewConversationMembers);
                    if (oldUsersOfConversationMembersListNewConversationMembers != null && !oldUsersOfConversationMembersListNewConversationMembers.equals(users)) {
                        oldUsersOfConversationMembersListNewConversationMembers.getConversationMembersList().remove(conversationMembersListNewConversationMembers);
                        oldUsersOfConversationMembersListNewConversationMembers = em.merge(oldUsersOfConversationMembersListNewConversationMembers);
                    }
                }
            }
            for (Notifications notificationsListNewNotifications : notificationsListNew) {
                if (!notificationsListOld.contains(notificationsListNewNotifications)) {
                    Users oldCreatorIdOfNotificationsListNewNotifications = notificationsListNewNotifications.getCreatorId();
                    notificationsListNewNotifications.setCreatorId(users);
                    notificationsListNewNotifications = em.merge(notificationsListNewNotifications);
                    if (oldCreatorIdOfNotificationsListNewNotifications != null && !oldCreatorIdOfNotificationsListNewNotifications.equals(users)) {
                        oldCreatorIdOfNotificationsListNewNotifications.getNotificationsList().remove(notificationsListNewNotifications);
                        oldCreatorIdOfNotificationsListNewNotifications = em.merge(oldCreatorIdOfNotificationsListNewNotifications);
                    }
                }
            }
            for (Notifications notificationsList1OldNotifications : notificationsList1Old) {
                if (!notificationsList1New.contains(notificationsList1OldNotifications)) {
                    notificationsList1OldNotifications.setReceiverId(null);
                    notificationsList1OldNotifications = em.merge(notificationsList1OldNotifications);
                }
            }
            for (Notifications notificationsList1NewNotifications : notificationsList1New) {
                if (!notificationsList1Old.contains(notificationsList1NewNotifications)) {
                    Users oldReceiverIdOfNotificationsList1NewNotifications = notificationsList1NewNotifications.getReceiverId();
                    notificationsList1NewNotifications.setReceiverId(users);
                    notificationsList1NewNotifications = em.merge(notificationsList1NewNotifications);
                    if (oldReceiverIdOfNotificationsList1NewNotifications != null && !oldReceiverIdOfNotificationsList1NewNotifications.equals(users)) {
                        oldReceiverIdOfNotificationsList1NewNotifications.getNotificationsList1().remove(notificationsList1NewNotifications);
                        oldReceiverIdOfNotificationsList1NewNotifications = em.merge(oldReceiverIdOfNotificationsList1NewNotifications);
                    }
                }
            }
            for (Submissions submissionsListNewSubmissions : submissionsListNew) {
                if (!submissionsListOld.contains(submissionsListNewSubmissions)) {
                    Users oldCreatorIdOfSubmissionsListNewSubmissions = submissionsListNewSubmissions.getCreatorId();
                    submissionsListNewSubmissions.setCreatorId(users);
                    submissionsListNewSubmissions = em.merge(submissionsListNewSubmissions);
                    if (oldCreatorIdOfSubmissionsListNewSubmissions != null && !oldCreatorIdOfSubmissionsListNewSubmissions.equals(users)) {
                        oldCreatorIdOfSubmissionsListNewSubmissions.getSubmissionsList().remove(submissionsListNewSubmissions);
                        oldCreatorIdOfSubmissionsListNewSubmissions = em.merge(oldCreatorIdOfSubmissionsListNewSubmissions);
                    }
                }
            }
            for (Bills billsListNewBills : billsListNew) {
                if (!billsListOld.contains(billsListNewBills)) {
                    Users oldCreatorIdOfBillsListNewBills = billsListNewBills.getCreatorId();
                    billsListNewBills.setCreatorId(users);
                    billsListNewBills = em.merge(billsListNewBills);
                    if (oldCreatorIdOfBillsListNewBills != null && !oldCreatorIdOfBillsListNewBills.equals(users)) {
                        oldCreatorIdOfBillsListNewBills.getBillsList().remove(billsListNewBills);
                        oldCreatorIdOfBillsListNewBills = em.merge(oldCreatorIdOfBillsListNewBills);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = users.getId();
                if (findUsers(id) == null) {
                    throw new NonexistentEntityException("The users with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws IllegalOrphanException, NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users users;
            try {
                users = em.getReference(Users.class, id);
                users.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The users with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            Instructors instructorsOrphanCheck = users.getInstructors();
            if (instructorsOrphanCheck != null) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Instructors " + instructorsOrphanCheck + " in its instructors field has a non-nullable creatorId field.");
            }
            List<Articles> articlesListOrphanCheck = users.getArticlesList();
            for (Articles articlesListOrphanCheckArticles : articlesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Articles " + articlesListOrphanCheckArticles + " in its articlesList field has a non-nullable creatorId field.");
            }
            List<Assignments> assignmentsListOrphanCheck = users.getAssignmentsList();
            for (Assignments assignmentsListOrphanCheckAssignments : assignmentsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Assignments " + assignmentsListOrphanCheckAssignments + " in its assignmentsList field has a non-nullable creatorId field.");
            }
            List<CourseReviews> courseReviewsListOrphanCheck = users.getCourseReviewsList();
            for (CourseReviews courseReviewsListOrphanCheckCourseReviews : courseReviewsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the CourseReviews " + courseReviewsListOrphanCheckCourseReviews + " in its courseReviewsList field has a non-nullable creatorId field.");
            }
            List<Courses> coursesListOrphanCheck = users.getCoursesList();
            for (Courses coursesListOrphanCheckCourses : coursesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Courses " + coursesListOrphanCheckCourses + " in its coursesList field has a non-nullable creatorId field.");
            }
            List<Conversations> conversationsListOrphanCheck = users.getConversationsList();
            for (Conversations conversationsListOrphanCheckConversations : conversationsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Conversations " + conversationsListOrphanCheckConversations + " in its conversationsList field has a non-nullable creatorId field.");
            }
            List<Enrollments> enrollmentsListOrphanCheck = users.getEnrollmentsList();
            for (Enrollments enrollmentsListOrphanCheckEnrollments : enrollmentsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Enrollments " + enrollmentsListOrphanCheckEnrollments + " in its enrollmentsList field has a non-nullable users field.");
            }
            List<Comments> commentsListOrphanCheck = users.getCommentsList();
            for (Comments commentsListOrphanCheckComments : commentsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Comments " + commentsListOrphanCheckComments + " in its commentsList field has a non-nullable creatorId field.");
            }
            List<ChatMessages> chatMessagesListOrphanCheck = users.getChatMessagesList();
            for (ChatMessages chatMessagesListOrphanCheckChatMessages : chatMessagesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the ChatMessages " + chatMessagesListOrphanCheckChatMessages + " in its chatMessagesList field has a non-nullable creatorId field.");
            }
            List<ConversationMembers> conversationMembersListOrphanCheck = users.getConversationMembersList();
            for (ConversationMembers conversationMembersListOrphanCheckConversationMembers : conversationMembersListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the ConversationMembers " + conversationMembersListOrphanCheckConversationMembers + " in its conversationMembersList field has a non-nullable users field.");
            }
            List<Notifications> notificationsListOrphanCheck = users.getNotificationsList();
            for (Notifications notificationsListOrphanCheckNotifications : notificationsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Notifications " + notificationsListOrphanCheckNotifications + " in its notificationsList field has a non-nullable creatorId field.");
            }
            List<Submissions> submissionsListOrphanCheck = users.getSubmissionsList();
            for (Submissions submissionsListOrphanCheckSubmissions : submissionsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Submissions " + submissionsListOrphanCheckSubmissions + " in its submissionsList field has a non-nullable creatorId field.");
            }
            List<Bills> billsListOrphanCheck = users.getBillsList();
            for (Bills billsListOrphanCheckBills : billsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Users (" + users + ") cannot be destroyed since the Bills " + billsListOrphanCheckBills + " in its billsList field has a non-nullable creatorId field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            List<Notifications> notificationsList1 = users.getNotificationsList1();
            for (Notifications notificationsList1Notifications : notificationsList1) {
                notificationsList1Notifications.setReceiverId(null);
                notificationsList1Notifications = em.merge(notificationsList1Notifications);
            }
            em.remove(users);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Users> findUsersEntities() {
        return findUsersEntities(true, -1, -1);
    }

    public List<Users> findUsersEntities(int maxResults, int firstResult) {
        return findUsersEntities(false, maxResults, firstResult);
    }

    private List<Users> findUsersEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Users.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Users findUsers(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Users.class, id);
        } finally {
            em.close();
        }
    }

    public int getUsersCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Users> rt = cq.from(Users.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
