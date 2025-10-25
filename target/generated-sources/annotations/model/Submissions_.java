package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Assignments;
import model.McqChoices;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Submissions.class)
@SuppressWarnings({"rawtypes", "deprecation"})
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