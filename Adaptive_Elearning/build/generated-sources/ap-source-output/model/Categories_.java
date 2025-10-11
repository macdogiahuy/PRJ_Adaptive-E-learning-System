package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Courses;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Categories.class)
public class Categories_ { 

    public static volatile SingularAttribute<Categories, String> path;
    public static volatile ListAttribute<Categories, Courses> coursesList;
    public static volatile SingularAttribute<Categories, Integer> courseCount;
    public static volatile SingularAttribute<Categories, String> description;
    public static volatile SingularAttribute<Categories, String> id;
    public static volatile SingularAttribute<Categories, String> title;
    public static volatile SingularAttribute<Categories, Boolean> isLeaf;

}