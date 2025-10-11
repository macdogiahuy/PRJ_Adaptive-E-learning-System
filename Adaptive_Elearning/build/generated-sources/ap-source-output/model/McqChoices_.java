package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.McqQuestions;
import model.Submissions;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(McqChoices.class)
public class McqChoices_ { 

    public static volatile SingularAttribute<McqChoices, McqQuestions> mcqQuestionId;
    public static volatile ListAttribute<McqChoices, Submissions> submissionsList;
    public static volatile SingularAttribute<McqChoices, String> id;
    public static volatile SingularAttribute<McqChoices, String> content;
    public static volatile SingularAttribute<McqChoices, Boolean> isCorrect;

}