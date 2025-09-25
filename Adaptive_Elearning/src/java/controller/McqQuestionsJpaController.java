/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Assignments;
import model.McqChoices;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.McqQuestions;

/**
 *
 * @author LP
 */
public class McqQuestionsJpaController implements Serializable {

    public McqQuestionsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(McqQuestions mcqQuestions) throws PreexistingEntityException, Exception {
        if (mcqQuestions.getMcqChoicesList() == null) {
            mcqQuestions.setMcqChoicesList(new ArrayList<McqChoices>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Assignments assignmentId = mcqQuestions.getAssignmentId();
            if (assignmentId != null) {
                assignmentId = em.getReference(assignmentId.getClass(), assignmentId.getId());
                mcqQuestions.setAssignmentId(assignmentId);
            }
            List<McqChoices> attachedMcqChoicesList = new ArrayList<McqChoices>();
            for (McqChoices mcqChoicesListMcqChoicesToAttach : mcqQuestions.getMcqChoicesList()) {
                mcqChoicesListMcqChoicesToAttach = em.getReference(mcqChoicesListMcqChoicesToAttach.getClass(), mcqChoicesListMcqChoicesToAttach.getId());
                attachedMcqChoicesList.add(mcqChoicesListMcqChoicesToAttach);
            }
            mcqQuestions.setMcqChoicesList(attachedMcqChoicesList);
            em.persist(mcqQuestions);
            if (assignmentId != null) {
                assignmentId.getMcqQuestionsList().add(mcqQuestions);
                assignmentId = em.merge(assignmentId);
            }
            for (McqChoices mcqChoicesListMcqChoices : mcqQuestions.getMcqChoicesList()) {
                McqQuestions oldMcqQuestionIdOfMcqChoicesListMcqChoices = mcqChoicesListMcqChoices.getMcqQuestionId();
                mcqChoicesListMcqChoices.setMcqQuestionId(mcqQuestions);
                mcqChoicesListMcqChoices = em.merge(mcqChoicesListMcqChoices);
                if (oldMcqQuestionIdOfMcqChoicesListMcqChoices != null) {
                    oldMcqQuestionIdOfMcqChoicesListMcqChoices.getMcqChoicesList().remove(mcqChoicesListMcqChoices);
                    oldMcqQuestionIdOfMcqChoicesListMcqChoices = em.merge(oldMcqQuestionIdOfMcqChoicesListMcqChoices);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findMcqQuestions(mcqQuestions.getId()) != null) {
                throw new PreexistingEntityException("McqQuestions " + mcqQuestions + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(McqQuestions mcqQuestions) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            McqQuestions persistentMcqQuestions = em.find(McqQuestions.class, mcqQuestions.getId());
            Assignments assignmentIdOld = persistentMcqQuestions.getAssignmentId();
            Assignments assignmentIdNew = mcqQuestions.getAssignmentId();
            List<McqChoices> mcqChoicesListOld = persistentMcqQuestions.getMcqChoicesList();
            List<McqChoices> mcqChoicesListNew = mcqQuestions.getMcqChoicesList();
            if (assignmentIdNew != null) {
                assignmentIdNew = em.getReference(assignmentIdNew.getClass(), assignmentIdNew.getId());
                mcqQuestions.setAssignmentId(assignmentIdNew);
            }
            List<McqChoices> attachedMcqChoicesListNew = new ArrayList<McqChoices>();
            for (McqChoices mcqChoicesListNewMcqChoicesToAttach : mcqChoicesListNew) {
                mcqChoicesListNewMcqChoicesToAttach = em.getReference(mcqChoicesListNewMcqChoicesToAttach.getClass(), mcqChoicesListNewMcqChoicesToAttach.getId());
                attachedMcqChoicesListNew.add(mcqChoicesListNewMcqChoicesToAttach);
            }
            mcqChoicesListNew = attachedMcqChoicesListNew;
            mcqQuestions.setMcqChoicesList(mcqChoicesListNew);
            mcqQuestions = em.merge(mcqQuestions);
            if (assignmentIdOld != null && !assignmentIdOld.equals(assignmentIdNew)) {
                assignmentIdOld.getMcqQuestionsList().remove(mcqQuestions);
                assignmentIdOld = em.merge(assignmentIdOld);
            }
            if (assignmentIdNew != null && !assignmentIdNew.equals(assignmentIdOld)) {
                assignmentIdNew.getMcqQuestionsList().add(mcqQuestions);
                assignmentIdNew = em.merge(assignmentIdNew);
            }
            for (McqChoices mcqChoicesListOldMcqChoices : mcqChoicesListOld) {
                if (!mcqChoicesListNew.contains(mcqChoicesListOldMcqChoices)) {
                    mcqChoicesListOldMcqChoices.setMcqQuestionId(null);
                    mcqChoicesListOldMcqChoices = em.merge(mcqChoicesListOldMcqChoices);
                }
            }
            for (McqChoices mcqChoicesListNewMcqChoices : mcqChoicesListNew) {
                if (!mcqChoicesListOld.contains(mcqChoicesListNewMcqChoices)) {
                    McqQuestions oldMcqQuestionIdOfMcqChoicesListNewMcqChoices = mcqChoicesListNewMcqChoices.getMcqQuestionId();
                    mcqChoicesListNewMcqChoices.setMcqQuestionId(mcqQuestions);
                    mcqChoicesListNewMcqChoices = em.merge(mcqChoicesListNewMcqChoices);
                    if (oldMcqQuestionIdOfMcqChoicesListNewMcqChoices != null && !oldMcqQuestionIdOfMcqChoicesListNewMcqChoices.equals(mcqQuestions)) {
                        oldMcqQuestionIdOfMcqChoicesListNewMcqChoices.getMcqChoicesList().remove(mcqChoicesListNewMcqChoices);
                        oldMcqQuestionIdOfMcqChoicesListNewMcqChoices = em.merge(oldMcqQuestionIdOfMcqChoicesListNewMcqChoices);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = mcqQuestions.getId();
                if (findMcqQuestions(id) == null) {
                    throw new NonexistentEntityException("The mcqQuestions with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            McqQuestions mcqQuestions;
            try {
                mcqQuestions = em.getReference(McqQuestions.class, id);
                mcqQuestions.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The mcqQuestions with id " + id + " no longer exists.", enfe);
            }
            Assignments assignmentId = mcqQuestions.getAssignmentId();
            if (assignmentId != null) {
                assignmentId.getMcqQuestionsList().remove(mcqQuestions);
                assignmentId = em.merge(assignmentId);
            }
            List<McqChoices> mcqChoicesList = mcqQuestions.getMcqChoicesList();
            for (McqChoices mcqChoicesListMcqChoices : mcqChoicesList) {
                mcqChoicesListMcqChoices.setMcqQuestionId(null);
                mcqChoicesListMcqChoices = em.merge(mcqChoicesListMcqChoices);
            }
            em.remove(mcqQuestions);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<McqQuestions> findMcqQuestionsEntities() {
        return findMcqQuestionsEntities(true, -1, -1);
    }

    public List<McqQuestions> findMcqQuestionsEntities(int maxResults, int firstResult) {
        return findMcqQuestionsEntities(false, maxResults, firstResult);
    }

    private List<McqQuestions> findMcqQuestionsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(McqQuestions.class));
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

    public McqQuestions findMcqQuestions(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(McqQuestions.class, id);
        } finally {
            em.close();
        }
    }

    public int getMcqQuestionsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<McqQuestions> rt = cq.from(McqQuestions.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
