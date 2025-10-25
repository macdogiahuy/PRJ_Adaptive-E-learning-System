package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import javax.annotation.processing.Generated;
import model.McqQuestions;
import model.Sections;
import model.Submissions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Assignments.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Assignments_ { 

    public static volatile SingularAttribute<Assignments, Integer> duration;
    public static volatile SingularAttribute<Assignments, Integer> questionCount;
    public static volatile SingularAttribute<Assignments, String> name;
    public static volatile SingularAttribute<Assignments, Users> creatorId;
    public static volatile ListAttribute<Assignments, McqQuestions> mcqQuestionsList;
    public static volatile SingularAttribute<Assignments, Double> gradeToPass;
    public static volatile ListAttribute<Assignments, Submissions> submissionsList;
    public static volatile SingularAttribute<Assignments, String> id;
    public static volatile SingularAttribute<Assignments, Sections> sectionId;

}