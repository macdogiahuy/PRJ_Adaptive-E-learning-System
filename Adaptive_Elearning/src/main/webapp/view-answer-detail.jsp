<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h1>Chi ti?t bài làm (L?n n?p: ${submission.id})</h1>
<hr>

<c:forEach var="userAnswer" items="${submission.mcqUserAnswers}" varStatus="loop">
    
    <c:set var="selectedChoice" value="${userAnswer.mcqChoices}" />
    <c:set var="question" value="${selectedChoice.questionId}" />
    
    <h3>Câu ${loop.index + 1}: ${question.content}</h3>
    
    <div class="choices-list">
        <c:forEach var="choice" items="${question.mcqChoicesList}">
            <div class="choice-item">
                
                <input type="radio" 
                       disabled 
                       <c:if test="${choice.id == selectedChoice.id}">
                           checked
                       </c:if>
                >
                <label>
                    <c:out value="${choice.content}" />
                </label>
                
            </div>
        </c:forEach>
    </div>
    
</c:forEach>