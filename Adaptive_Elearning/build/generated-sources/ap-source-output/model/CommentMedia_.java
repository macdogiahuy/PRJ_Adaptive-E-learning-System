package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.CommentMediaPK;
import model.Comments;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(CommentMedia.class)
public class CommentMedia_ { 

    public static volatile SingularAttribute<CommentMedia, Comments> comments;
    public static volatile SingularAttribute<CommentMedia, String> type;
    public static volatile SingularAttribute<CommentMedia, CommentMediaPK> commentMediaPK;
    public static volatile SingularAttribute<CommentMedia, String> url;

}