package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Comments;
import model.LectureMaterial;
import model.Sections;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Lectures.class)
public class Lectures_ { 

    public static volatile ListAttribute<Lectures, LectureMaterial> lectureMaterialList;
    public static volatile ListAttribute<Lectures, Comments> commentsList;
    public static volatile SingularAttribute<Lectures, Date> creationTime;
    public static volatile SingularAttribute<Lectures, Date> lastModificationTime;
    public static volatile SingularAttribute<Lectures, String> id;
    public static volatile SingularAttribute<Lectures, Boolean> isPreviewable;
    public static volatile SingularAttribute<Lectures, Sections> sectionId;
    public static volatile SingularAttribute<Lectures, String> title;
    public static volatile SingularAttribute<Lectures, String> content;

}