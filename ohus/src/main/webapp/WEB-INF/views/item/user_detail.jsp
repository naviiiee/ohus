<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${item.item_name} | 내일의 집</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/item.css">
	<script type="text/javascript" src = "${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src = "${pageContext.request.contextPath}/js/item.review.js"></script>
	<style type="text/css">
		*{margin:0; padding:0;}
		a.button{display:inline-block; padding: 10px 20px; text-decoration:none; color:#fff; background:#000; margin:20px;}
		.modal{
		  display:none;
		  position:fixed; 
		  width:100%; height:100%;
		  top:0; left:0; 
		  background:rgba(0,0,0,0.3);
		}
		.modal-con{
		  display:none;
		  position:fixed;
		  top:50%; left:50%;
		  transform: translate(-50%,-50%);
		  max-width:70%;
		  min-height:50%;
		  background:#fff;
		}
		.modal-con .title{
		  font-size:20px; 
		  padding: 20px; 
		  background :#35C5F0;
		}
		.modal-con .con{
		  font-size:15px; line-height:1.3;
		  padding: 30px;
		}
		.modal-con .close{
		  display:block;
		  position:absolute;
		  width:30px; height:30px;
		  border-radius:50%; 
		  border: 3px solid #000;
		  text-align:center; line-height: 30px;
		  text-decoration:none;
		  color:#000; font-size:20px; font-weight: bold;
		  right:10px; top:10px;
		}
	</style>
	
	<script type="text/javascript" src = "${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src = "${pageContext.request.contextPath}/js/item.fav.js"></script>
	<script type="text/javascript">
		$(function(){
			$('#order_quantity').on('keyup mouseup', function(){
				if($('#order_quantity').val() == ''){
					$('#item_total_txt').text('총 주문 금액 : 0원');
					return;
				}
				if($('#order_quantity').val() <= 0){
					$('#order_quantity').val('');
					return;
				}
				if(Number($('#item_stock').val()) < $('#order_quantity').val()){
					alert('수량이 부족합니다.');
					$('#order_quantity').val('');
					$('#item_total_txt').text('총 주문 금액 : 0원');
					return;
				}
				
				//총 주문 금액 표시
				let total = $('#item_price').val() * $('#order_quantity').val();
				$('#item_total_txt').text('총 주문 금액 : ' + total.toLocaleString() + '원');//숫자 세자리마다 쉼표처리
			});
			
			//장바구니에 상품을 담기 위한 이벤트 처리
			$('#item_cart').submit(function(){
				//기본 이벤트 제거
				event.preventDefault();
				if($('#order_quantity').val() == ''){
					alert('수량을 입력하세요.');
					$('#order_quantity').focus();
					return false;
				}
				let form_data = $(this).serialize();
				$.ajax({
					url:'../cart/write.do',
					type:'post',
					data:form_data,
					dataType:'json',
					success:function(param){
						if(param.result == 'logout'){
							alert('로그인 필요');
						}else if(param.result == 'success'){
							alert('장바구니에 담았습니다.');
							location.href='../cart/list.do';
						}else if(param.result == 'over_quantity'){
							alert('수량 초과');
						}else{
							alert('장바구니 오류');
						}
					},
					error:function(){
						alert('네트워크 오류 발생');
					}
				})
			});
			
			$('input[type="search"]').attr('placeholder','상품 검색');
			
			function searchData(){
				let data = $('input[type="search"]').val();
				if(data == ''){
					alert('검색어를 입력하세요.');
					$('input[type="search"]').val('').focus();
					return false;
				}
				location.href="userList.do?keyword="+data;
			};
			
			$('input[type="search"]').keypress(function(){
				if(event.keyCode==13){
					searchData();	
				}
				
			});	
			
			$('#directBuy').submit(function(){
				if($('#order_quantity').val() == ''){
					alert('수량을 입력하세요.');
					$('#order_quantity').focus();
					return false;
				}
			});
			
			$('#order_quantity').change(function(){
				$('#direct_quantity').val($(this).val());
			});
			
			$('#header1').on("click", function(){header1.classList.add('active');});
			$('#header2').on("click", function(){header2.classList.add('active');});
			$('#header3').on("click", function(){header3.classList.add('active');});
			$('#header4').on("click", function(){header4.classList.add('active');});
			$('#header5').on("click", function(){header5.classList.add('active');});
			$('#header6').on("click", function(){header6.classList.add('active');});
			
		});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp"/>
		<jsp:include page="/WEB-INF/views/item/item_header.jsp"/>
		<%-- 내용 시작 --%>
		<div class="content-main">
			<c:if test="${item.item_status == 1}">
				<div class="result-display">
					<div class="align-center">
						판매 중지 상품
						<p>
						<input type="button" value="판매상품 보기" onclick="location.href='itemList.do'">
					</div>
				</div>
			</c:if>
			<c:if test="${item.item_status == 2}">
				<div class="imagedetail">
					<div class="item-image">
						<img src="${pageContext.request.contextPath}/upload/${item.item_photo1}" width="550" height="550">
					</div>
					<div class="item-detail"><br><br>
						<form id="item_cart">
							<input type="hidden" name="item_num" value="${item.item_num}" id="item_num">
							<input type="hidden" name="item_price" value="${item.item_price}" id="item_price">
							<input type="hidden" name="item_stock" value="${item.item_stock}" id="item_stock">
							<ul>
								<li><h1>${item.item_name}</h1></li>
								<li id="price"><b><fmt:formatNumber value="${item.item_price}"/>원</b></li>
								<li>남은 수량 : <span><fmt:formatNumber value="${item.item_stock}"/></span></li>
								<li>조회수 : <fmt:formatNumber value="${item.item_hit}"/>회</li>
								<li><font color="#35c5f0"><big>★</big></font> <small><fmt:formatNumber value="${avgscore}" pattern=".00"/></small> | <span id="reviewCount"> ${reviewCount}개 리뷰</span></li>
								<c:if test="${item.item_stock > 0}">
									<li>
										<label for="order_quantity">구매 수량 :</label>
										<input type="number" name="order_quantity" 
										min="1" max="${item.item_stock}" 
										autocomplete="off" id="order_quantity">
									</li>
									<li>
										<img id="output_fav" data-num="${item.item_num}" src="${pageContext.request.contextPath}/images/fav01.gif" width="50">
										<span id="output_fcount"></span>회
									</li>
									<li id="item_total_txt">총 주문 금액 : 0원</li>
									<li class="list-cart-btn">
										<button class="btn btn-cart" type="submit">장바구니</button>
									</li>
								</c:if>
								<c:if test="${item.item_stock <= 0}">
									<li>
										<span>품절</span>
									</li>
								</c:if>
							</ul>
						</form>
						<form id="directBuy" action="${pageContext.request.contextPath}/order/directOrderForm.do" method="POST">
							<input type="hidden" name="order_quantity" id="direct_quantity">
							<input type="hidden" name="item_num" value="${item.item_num}">
							<button class="btn btn-buy" type="submit">바로 구매</button>
						</form>
					</div>
				</div>
				<p>
				<br>
				<div class="item-header__nav">
					<div class="item-header">
						<div class="inner">
							<nav>
								<a id="header7" class="item-header__item" href="#item_detail">상품정보</a> 
								<a id="header8" class="item-header__item" href="#item_review">리뷰 <small>${reviewCount}개</small></a>  
								<a id="header9" class="item-header__item" href="#item_inquiry">문의</a> 
							</nav>
						</div>
					</div>
				</div>
				
				<p>
				<div id="item_detail">
					<img src="${pageContext.request.contextPath}/upload/${item.item_photo2}" width="1000" height="1000"><br>
					<img src="${pageContext.request.contextPath}/upload/${item.item_photo3}" width="1000" height="1000"><br>
					<p id="detail-content">
						${item.item_content}
					</p>	
				</div>
			<hr size="1" noshade="noshade" width="100%"><br>
			<div id="item_review">
				<div class="item-review-header">
					<h3>상품 후기 <font color="#35c5f0">${reviewCount}개</font></h3>
				</div>
				<%-- 후기 목록 출력 시작 --%>
				<c:if test="${reviewCount == 0}">
					아직 후기가 없어요...<small>따끈따끈</small>
				</c:if>
				<div id="output"></div>
				<div class="paging-button" style="display:none">
					<input type="button" value="후기 더보기">
				</div>
				<%-- 후기 목록 출력 끝 --%>
			</div>
			<hr size="1" noshade="noshade" width="100%">	
			
			<!-- 상품문의 부분 시작 -->
			<div id="item_inquiry">
				<h2>상품 문의</h2>
				<input type="button" value="문의하기" onclick="location.href='${pageContext.request.contextPath}/qna/writeQnaForm.do'"
					<c:if test="${empty user_num}">disabled="disabled"</c:if> data-item="${item_num}">
				<c:if test="${qnaCount == 0}">
				<div class="result-display">
					등록된 문의가 없습니다.
				</div>
				</c:if>
				<c:if test="${qnaCount > 0}">
				<table>
					<tr style="pointer-events: none;">
						<th width="7%">번호</th>
						<th>문의카테</th>
						<th width="40%">제목</th>
						<th>작성자</th>
						<th width="13%">작성일</th>
						<th>상태</th>
					</tr>
					
					<c:forEach var="qna" items="${qnaList}">
					<c:if test="${item.item_num == qna.item_num}">
					<tr>
						<td>${qna.qna_num}</td>
						<td>
							<c:if test="${qna.qna_category == 1}">[상품]</c:if>
							<c:if test="${qna.qna_category == 2}">[배송]</c:if>
							<c:if test="${qna.qna_category == 3}">[반품]</c:if>
							<c:if test="${qna.qna_category == 4}">[교환]</c:if>
							<c:if test="${qna.qna_category == 5}">[환불]</c:if>
							<c:if test="${qna.qna_category == 6}">[기타]</c:if>
						</td>
						<td style="text-align:left;">
							<a href="${pageContext.request.contextPath}/qna/detailQna.do?qna_num=${qna.qna_num}">
								${qna.qna_title}
							</a>
						</td>
						<td>${qna.id}</td>
						<td>${qna.qna_regdate}</td>
						<td>
							<c:if test="${qna.qna_status == 1}"><span style="color:blue;">처리전</span></c:if>
							<c:if test="${qna.qna_status == 2}"><span style="color:red;"><b>처리완료</b></span></c:if>
						</td>
					</tr>
					</c:if>
					</c:forEach>
				</table>
				</c:if>
			</div>
			<!-- 상품문의 부분 끝 -->
			</c:if>
		</div>
		<%-- 내용 끝 --%>
	</div>
</body>
</html>