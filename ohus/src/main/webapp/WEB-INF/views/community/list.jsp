<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티-일상</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <style>
        .sorting-options,
        .result-display,
        .content-main {
            margin-top: 1cm;
            margin-bottom: 1cm;
        }
        .sorting-options select {
            display: none;
        }
        
        .sorting-options:hover select {
            display: block;
        }
        
        .sorting-options select {
            color: #828C94;
        }
        
        .sorting-options .sort-select {
            display: none;
        }
        
        .sorting-options:hover .sort-select {
            display: block;
        }
        
        .sorting-options .sort-select option {
            display: block;
        }
		.community-container {
    		display: flex;
   			flex-wrap: wrap;
    		align-items: flex-start;
    		height: 100%;
    		margin: 0;
    		display: flex;
    		justify-content: center;
    		align-items: center;
		}

		.community {
   			width: 250px; /* Adjust the width as needed */
    		margin: 10px;
		}
		.align-center {
    		display: flex;
    		justify-content: center;
		}		
		
    </style>
</head>
<body>
<div class="page-main">
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <jsp:include page="/WEB-INF/views/community/community_header.jsp"/>
    <!-- 내용 시작 -->
    <div class="content-main">
        <div class="sorting-options">
            정렬 
            <span style="color: #828C94; cursor: pointer;" onclick="toggleSortOptions()">▼</span>
            <select id="sortSelect" name="sort" onchange="this.form.submit()" class="sort-select">
                <option value="latest" <c:if test="${param.sort == 'latest' || empty param.sort}">selected</c:if>>최신순</option>
                <option value="views" <c:if test="${param.sort == 'views'}">selected</c:if>>조회순</option>
                <option value="likes" <c:if test="${param.sort == 'likes'}">selected</c:if>>좋아요순</option>
            </select>
        </div>
        <div class="result-display">
        전체 ${count}
    	</div>
        <div class = "community-main">
        <div class="community-container">
        <c:if test="${count == 0}">
            <div class="result-display">
                표시할 게시물이 없습니다.
            </div>
        </c:if>
        
        <c:if test="${count > 0}">
            
                <c:forEach var="board" items="${list}">
                <div class="community">
                   
            
                        <a href="${pageContext.request.contextPath}/community/detail.do?cboard_num=${board.cboard_num}">
                            <img src="${pageContext.request.contextPath}/upload/${board.cboard_photo1}" width="100%">
                            ${board.cboard_title}
                           </a>
                            <br>
                            
                            <c:choose>
                                <c:when test="${not empty board.photo}">
                                    <img src="${board.photo}" alt="photo" width="15" height="15">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/face.png" width="15" height="15">
                                </c:otherwise>
                            </c:choose>
                            ${board.id}
                            <br>
                            좋아요 ${favCount}
                            조회 ${board.cboard_hit}
                           </div>
                           </c:forEach>
                           </c:if>
                           </div>
                           <c:if test="${count != 0}">
                           <div class = "align-center">${page}</div>
							</c:if>
	</div>
	</div>
    <!-- 내용 끝 -->

<script>
    function toggleSortOptions() {
        var sortSelect = document.getElementById('sortSelect');
        sortSelect.classList.toggle('sort-select');
    }
</script>
</body>
</html>
