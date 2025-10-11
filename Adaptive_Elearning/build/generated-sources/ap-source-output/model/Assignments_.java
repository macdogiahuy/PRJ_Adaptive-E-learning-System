package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.McqQuestions;
import model.Sections;
import model.Submissions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Assignments.class)
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