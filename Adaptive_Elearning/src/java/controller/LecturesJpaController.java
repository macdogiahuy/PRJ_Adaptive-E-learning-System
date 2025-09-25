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
import model.Sections;
import model.LectureMaterial;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Comments;
import model.Lectures;

/**
 *
 * @author LP
 */
public class LecturesJpaController implements Serializable {

    public LecturesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Lectures lectures) throws PreexistingEntityException, Exception {
        if (lectures.getLectureMaterialList() == null) {
            lectures.setLectureMaterialList(new ArrayList<LectureMaterial>());
        }
        if (lectures.getCommentsList() == null) {
            lectures.setCommentsList(new ArrayList<Comments>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Sections sectionId = lectures.getSectionId();
            if (sectionId != null) {
                sectionId = em.getReference(sectionId.getClass(), sectionId.getId());
                lectures.setSectionId(sectionId);
            }
            List<LectureMaterial> attachedLectureMaterialList = new ArrayList<LectureMaterial>();
            for (LectureMaterial lectureMaterialListLectureMaterialToAttach : lectures.getLectureMaterialList()) {
                lectureMaterialListLectureMaterialToAttach = em.getReference(lectureMaterialListLectureMaterialToAttach.getClass(), lectureMaterialListLectureMaterialToAttach.getLectureMaterialPK());
                attachedLectureMaterialList.add(lectureMaterialListLectureMaterialToAttach);
            }
            lectures.setLectureMaterialList(attachedLectureMaterialList);
            List<Comments> attachedCommentsList = new ArrayList<Comments>();
            for (Comments commentsListCommentsToAttach : lectures.getCommentsList()) {
                commentsListCommentsToAttach = em.getReference(commentsListCommentsToAttach.getClass(), commentsListCommentsToAttach.getId());
                attachedCommentsList.add(commentsListCommentsToAttach);
            }
            lectures.setCommentsList(attachedCommentsList);
            em.persist(lectures);
            if (sectionId != null) {
                sectionId.getLecturesList().add(lectures);
                sectionId = em.merge(sectionId);
            }
            for (LectureMaterial lectureMaterialListLectureMaterial : lectures.getLectureMaterialList()) {
                Lectures oldLecturesOfLectureMaterialListLectureMaterial = lectureMaterialListLectureMaterial.getLectures();
                lectureMaterialListLectureMaterial.setLectures(lectures);
                lectureMaterialListLectureMaterial = em.merge(lectureMaterialListLectureMaterial);
                if (oldLecturesOfLectureMaterialListLectureMaterial != null) {
                    oldLecturesOfLectureMaterialListLectureMaterial.getLectureMaterialList().remove(lectureMaterialListLectureMaterial);
                    oldLecturesOfLectureMaterialListLectureMaterial = em.merge(oldLecturesOfLectureMaterialListLectureMaterial);
                }
            }
            for (Comments commentsListComments : lectures.getCommentsList()) {
                Lectures oldLectureIdOfCommentsListComments = commentsListComments.getLectureId();
                commentsListComments.setLectureId(lectures);
                commentsListComments = em.merge(commentsListComments);
                if (oldLectureIdOfCommentsListComments != null) {
                    oldLectureIdOfCommentsListComments.getCommentsList().remove(commentsListComments);
                    oldLectureIdOfCommentsListComments = em.merge(oldLectureIdOfCommentsListComments);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findLectures(lectures.getId()) != null) {
                throw new PreexistingEntityException("Lectures " + lectures + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Lectures lectures) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Lectures persistentLectures = em.find(Lectures.class, lectures.getId());
            Sections sectionIdOld = persistentLectures.getSectionId();
            Sections sectionIdNew = lectures.getSectionId();
            List<LectureMaterial> lectureMaterialListOld = persistentLectures.getLectureMaterialList();
            List<LectureMaterial> lectureMaterialListNew = lectures.getLectureMaterialList();
            List<Comments> commentsListOld = persistentLectures.getCommentsList();
            List<Comments> commentsListNew = lectures.getCommentsList();
            List<String> illegalOrphanMessages = null;
            for (LectureMaterial lectureMaterialListOldLectureMaterial : lectureMaterialListOld) {
                if (!lectureMaterialListNew.contains(lectureMaterialListOldLectureMaterial)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain LectureMaterial " + lectureMaterialListOldLectureMaterial + " since its lectures field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (sectionIdNew != null) {
                sectionIdNew = em.getReference(sectionIdNew.getClass(), sectionIdNew.getId());
                lectures.setSectionId(sectionIdNew);
            }
            List<LectureMaterial> attachedLectureMaterialListNew = new ArrayList<LectureMaterial>();
            for (LectureMaterial lectureMaterialListNewLectureMaterialToAttach : lectureMaterialListNew) {
                lectureMaterialListNewLectureMaterialToAttach = em.getReference(lectureMaterialListNewLectureMaterialToAttach.getClass(), lectureMaterialListNewLectureMaterialToAttach.getLectureMaterialPK());
                attachedLectureMaterialListNew.add(lectureMaterialListNewLectureMaterialToAttach);
            }
            lectureMaterialListNew = attachedLectureMaterialListNew;
            lectures.setLectureMaterialList(lectureMaterialListNew);
            List<Comments> attachedCommentsListNew = new ArrayList<Comments>();
            for (Comments commentsListNewCommentsToAttach : commentsListNew) {
                commentsListNewCommentsToAttach = em.getReference(commentsListNewCommentsToAttach.getClass(), commentsListNewCommentsToAttach.getId());
                attachedCommentsListNew.add(commentsListNewCommentsToAttach);
            }
            commentsListNew = attachedCommentsListNew;
            lectures.setCommentsList(commentsListNew);
            lectures = em.merge(lectures);
            if (sectionIdOld != null && !sectionIdOld.equals(sectionIdNew)) {
                sectionIdOld.getLecturesList().remove(lectures);
                sectionIdOld = em.merge(sectionIdOld);
            }
            if (sectionIdNew != null && !sectionIdNew.equals(sectionIdOld)) {
                sectionIdNew.getLecturesList().add(lectures);
                sectionIdNew = em.merge(sectionIdNew);
            }
            for (LectureMaterial lectureMaterialListNewLectureMaterial : lectureMaterialListNew) {
                if (!lectureMaterialListOld.contains(lectureMaterialListNewLectureMaterial)) {
                    Lectures oldLecturesOfLectureMaterialListNewLectureMaterial = lectureMaterialListNewLectureMaterial.getLectures();
                    lectureMaterialListNewLectureMaterial.setLectures(lectures);
                    lectureMaterialListNewLectureMaterial = em.merge(lectureMaterialListNewLectureMaterial);
                    if (oldLecturesOfLectureMaterialListNewLectureMaterial != null && !oldLecturesOfLectureMaterialListNewLectureMaterial.equals(lectures)) {
                        oldLecturesOfLectureMaterialListNewLectureMaterial.getLectureMaterialList().remove(lectureMaterialListNewLectureMaterial);
                        oldLecturesOfLectureMaterialListNewLectureMaterial = em.merge(oldLecturesOfLectureMaterialListNewLectureMaterial);
                    }
                }
            }
            for (Comments commentsListOldComments : commentsListOld) {
                if (!commentsListNew.contains(commentsListOldComments)) {
                    commentsListOldComments.setLectureId(null);
                    commentsListOldComments = em.merge(commentsListOldComments);
                }
            }
            for (Comments commentsListNewComments : commentsListNew) {
                if (!commentsListOld.contains(commentsListNewComments)) {
                    Lectures oldLectureIdOfCommentsListNewComments = commentsListNewComments.getLectureId();
                    commentsListNewComments.setLectureId(lectures);
                    commentsListNewComments = em.merge(commentsListNewComments);
                    if (oldLectureIdOfCommentsListNewComments != null && !oldLectureIdOfCommentsListNewComments.equals(lectures)) {
                        oldLectureIdOfCommentsListNewComments.getCommentsList().remove(commentsListNewComments);
                        oldLectureIdOfCommentsListNewComments = em.merge(oldLectureIdOfCommentsListNewComments);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = lectures.getId();
                if (findLectures(id) == null) {
                    throw new NonexistentEntityException("The lectures with id " + id + " no longer exists.");
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
            Lectures lectures;
            try {
                lectures = em.getReference(Lectures.class, id);
                lectures.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The lectures with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<LectureMaterial> lectureMaterialListOrphanCheck = lectures.getLectureMaterialList();
            for (LectureMaterial lectureMaterialListOrphanCheckLectureMaterial : lectureMaterialListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Lectures (" + lectures + ") cannot be destroyed since the LectureMaterial " + lectureMaterialListOrphanCheckLectureMaterial + " in its lectureMaterialList field has a non-nullable lectures field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Sections sectionId = lectures.getSectionId();
            if (sectionId != null) {
                sectionId.getLecturesList().remove(lectures);
                sectionId = em.merge(sectionId);
            }
            List<Comments> commentsList = lectures.getCommentsList();
            for (Comments commentsListComments : commentsList) {
                commentsListComments.setLectureId(null);
                commentsListComments = em.merge(commentsListComments);
            }
            em.remove(lectures);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Lectures> findLecturesEntities() {
        return findLecturesEntities(true, -1, -1);
    }

    public List<Lectures> findLecturesEntities(int maxResults, int firstResult) {
        return findLecturesEntities(false, maxResults, firstResult);
    }

    private List<Lectures> findLecturesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Lectures.class));
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

    public Lectures findLectures(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Lectures.class, id);
        } finally {
            em.close();
        }
    }

    public int getLecturesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Lectures> rt = cq.from(Lectures.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
