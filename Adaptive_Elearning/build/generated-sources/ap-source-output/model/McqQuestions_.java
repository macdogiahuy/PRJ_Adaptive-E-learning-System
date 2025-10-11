package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Assignments;
import model.McqChoices;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(McqQuestions.class)
public class McqQuestions_ { 

    public static volatile ListAttribute<McqQuestions, McqChoices> mcqChoicesList;
    public static volatile SingularAttribute<McqQuestions, String> id;
    public static volatile SingularAttribute<McqQuestions, Assignments> assignmentId;
    public static volatile SingularAttribute<McqQuestions, String> content;

}