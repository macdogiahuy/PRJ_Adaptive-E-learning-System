package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Assignments;
import model.McqChoices;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Submissions.class)
public class Submissions_ { 

    public static volatile SingularAttribute<Submissions, Integer> timeSpentInSec;
    public static volatile ListAttribute<Submissions, McqChoices> mcqChoicesList;
    public static volatile SingularAttribute<Submissions, Date> creationTime;
    public static volatile SingularAttribute<Submissions, Date> lastModificationTime;
    public static volatile SingularAttribute<Submissions, Users> creatorId;
    public static volatile SingularAttribute<Submissions, String> lastModifierId;
    public static volatile SingularAttribute<Submissions, String> id;
    public static volatile SingularAttribute<Submissions, Assignments> assignmentId;
    public static volatile SingularAttribute<Submissions, Double> mark;

}