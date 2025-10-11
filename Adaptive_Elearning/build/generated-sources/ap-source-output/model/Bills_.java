package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Enrollments;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Bills.class)
public class Bills_ { 

    public static volatile SingularAttribute<Bills, String> note;
    public static volatile SingularAttribute<Bills, Long> amount;
    public static volatile SingularAttribute<Bills, Date> creationTime;
    public static volatile SingularAttribute<Bills, Boolean> isSuccessful;
    public static volatile SingularAttribute<Bills, Users> creatorId;
    public static volatile SingularAttribute<Bills, String> action;
    public static volatile SingularAttribute<Bills, String> clientTransactionId;
    public static volatile SingularAttribute<Bills, String> id;
    public static volatile SingularAttribute<Bills, String> transactionId;
    public static volatile SingularAttribute<Bills, String> gateway;
    public static volatile SingularAttribute<Bills, String> token;
    public static volatile SingularAttribute<Bills, Enrollments> enrollments;

}