<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="${contextPath}/css/MainCss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<script>
	document.addEventListener("DOMContentLoaded", function() {
	    var menuItems = document.querySelectorAll('.menu > li > a');
	
	    menuItems.forEach(function(item) {
	        item.addEventListener('click', function(event) {
	            event.preventDefault(); // 기본 동작을 막습니다.
	            
	            var parentLi = this.parentElement;
	            parentLi.classList.toggle('fixed'); // 'fixed' 클래스를 토글합니다.
	            
	            // 다른 모든 메뉴 항목에서 'fixed' 클래스를 제거합니다.
	            menuItems.forEach(function(otherItem) {
	                if (otherItem !== item) {
	                    otherItem.parentElement.classList.remove('fixed');
	                }
	            });
	        });
	    });
	});
</script>
<script type="text/javascript">
	$(document).ready(function(){
		var UserId = "<%= (String)session.getAttribute("id") %>";
		console.log("Header 사용자의 아이디 : " + UserId);
		$.ajax({
			url: '${contextPath}/Information/AjaxSet/UserRightCheck.jsp',
			type: 'POST',
			data: {User_Id : UserId},
			success:function(response){
				var popupWidth = 2514;
			    var popupHeight = 1054;

			    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
			    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
			    
			    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
			    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
			    var xPos, yPos;
				
			    if (width == 2560 && height == 1440) {
			        xPos = (2560 / 2) - (popupWidth / 2);
			        yPos = (1440 / 2) - (popupHeight / 2);
			    } else if (width == 1920 && height == 1080) {
			        xPos = (1920 / 2) - (popupWidth / 2);
			        yPos = (1080 / 2) - (popupHeight / 2);
			    } else {
			        var monitorWidth = 2560;
			        var monitorHeight = 1440;
			        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
			        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
			    }
				if(response.trim() === 'NOPE'){
					window.open("${contextPath}/Authority/AccessReq.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
				}
			}
		})
	});
</script>
<script>
        const data1 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [10, 20, 30, 10, 20, 10],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data2 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [15, 10, 25, 5, 20, 25],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data3 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [20, 20, 20, 10, 15, 15],
                backgroundColor: [
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)'
                ],
                borderWidth: 1
            }]
        };

        // Repeat similarly for data4 to data9
        const data4 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [5, 25, 20, 15, 10, 25],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)'
                ],
                borderColor: [
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data5 = {
        	    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
        	    datasets: [
        	        {
        	            label: 'Dataset 1',
        	            type: 'line', // 선차트 유형
        	            borderColor: 'rgb(54, 162, 235)', // 선 색상
        	            borderWidth: 2,
        	            fill: false,
        	            data: [5, 25, 20, 15, 10, 25],
        	        },
        	        {
        	            label: 'Dataset 2',
        	            type: 'bar', // 막대차트 유형
        	            backgroundColor: 'rgba(255, 99, 132, 0.2)', // 막대 배경 색상
        	            borderColor: 'rgba(255, 99, 132, 1)', // 막대 테두리 색상
        	            borderWidth: 1,
        	            data: [5, 25, 20, 15, 10, 25],
        	        },
        	        // 추가적인 데이터셋을 여기에 넣을 수 있습니다.
        	    ]
        	};

        const data6 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [20, 10, 30, 15, 15, 10],
                backgroundColor: [
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data7 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [10, 10, 10, 20, 30, 20],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)'
                ],
                borderColor: [
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data8 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [25, 15, 10, 20, 10, 20],
                backgroundColor: [
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)'
                ],
                borderWidth: 1
            }]
        };

        const data9 = {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                data: [15, 20, 10, 20, 15, 20],
                backgroundColor: [
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)',
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)'
                ],
                borderColor: [
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)'
                ],
                borderWidth: 1
            }]
        };
        const config1 = {
        	    type: 'bar', // 차트 유형을 'bar'로 변경
        	    data: data1,
        	    options: {
        	        indexAxis: 'y', // 바 차트를 수평으로 표시
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            },
            	        title: {
            	        	display: true,
            	        	text: '수평 바 차트',
            	        	position: 'bottom'
            	        }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        // type 속성은 차트의 유형을 지정.
        // data 속성은 차트에 표시될 데이터를 정의.
        // options 속성은 차트의 다양한 옵션을 설정
        // responsive: true : 이 옵션은 차트가 반응형(responsive)으로 동작하게 한다.
        // maintainAspectRatio: false : 이 옵션은 차트의 가로 세로 비율을 유지하지 않도록 설정하여, 사용자가 크기를 조정할 수 있다.
        const config2 = {
        	    type: 'bar',
        	    data: data2,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            },
        	            title: {
            	        	display: true,
            	        	text: '바 차트',
            	        	position: 'bottom'
            	        }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config3 = {
        	    type: 'pie',
        	    data: data3,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                /* formatter: (value, context) => {
        	                    const label = context.chart.data.labels[context.dataIndex]; // 라벨 가져오기
        	                    return `${label}: ${value}`; // 라벨과 데이터 값 표시
        	                } */
        	                formatter: (value, context) => {
        	                    // 데이터 값과 라벨 함께 반환
        	                    const label = context.chart.data.labels[context.dataIndex];
        	                    /* return `${label}: ${value}`; */
        	                    return label + '\n ' +  value;
        	                }
        	            },
        	            title: {
            	        	display: true,
            	        	text: '파이차트',
            	        	position: 'bottom',
            	        }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config4 = {
        	    type: 'pie',
        	    data: data4,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config5 = {
        	    type: 'bar', // 기본 차트 유형을 막대차트로 설정
        	    data: data5,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: function(context) {
        	                    return context.dataset.type !== 'line'; // 선 차트 데이터 포인트 라벨 숨김
        	                }
        	            },
        	            title: {
            	        	display: true,
            	        	text: 'mixed chart',
            	        	position: 'bottom',
            	        	font:{
            	        		size: 16
            	        	}
            	        }
        	            // 여기에 추가적인 플러그인 옵션을 넣을 수 있습니다.
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config6 = {
        	    type: 'pie',
        	    data: data6,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config7 = {
        	    type: 'pie',
        	    data: data7,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config8 = {
        	    type: 'pie',
        	    data: data8,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};
        const config9 = {
        	    type: 'pie',
        	    data: data9,
        	    options: {
        	        responsive: true,
        	        maintainAspectRatio: false,
        	        plugins: {
        	            legend: {
        	                display: false // 범례 숨김
        	            },
        	            tooltip: {
        	                enabled: false // 툴팁 숨김
        	            },
        	            datalabels: {
        	                display: true, // 데이터 라벨 표시
        	                color: 'black',
        	                formatter: (value, context) => {
        	                    return value; // 데이터 값을 라벨에 표시
        	                }
        	            }
        	        }
        	    },
        	    plugins: [ChartDataLabels] // 데이터 라벨 플러그인 사용
        	};

        window.onload = function() {
            new Chart(document.getElementById('chart1').getContext('2d'), config1);
            new Chart(document.getElementById('chart2').getContext('2d'), config2);
            new Chart(document.getElementById('chart3').getContext('2d'), config3);
            new Chart(document.getElementById('chart4').getContext('2d'), config4);
            new Chart(document.getElementById('chart5').getContext('2d'), config5);
            new Chart(document.getElementById('chart6').getContext('2d'), config6);
            new Chart(document.getElementById('chart7').getContext('2d'), config7);
            new Chart(document.getElementById('chart8').getContext('2d'), config8);
            new Chart(document.getElementById('chart9').getContext('2d'), config9);
        };
    </script>
<title>Insert title here</title>
</head>
<body>
	<jsp:include page="HeaderTest.jsp"></jsp:include>
	<div class="content-wrapper">
		<div class="Main-side" id="sidemenu">
			<ul class="menu">
				<li>
				<%
				String BizSql = "SELECT * FROM project.bizarea";
		      	PreparedStatement Bizpstmt = conn.prepareStatement(BizSql);
		     	ResultSet Bizrs = Bizpstmt.executeQuery();
		      	%>
				<a href="#">BizArea</a>
					<ul class="submenu">
		      	<%
		     	 while(Bizrs.next()){
		      	%>
				<li><a href="#"><%=Bizrs.getString("BA_Name") %></a></li>
		      	<%
		      	}
		      	%>
					</ul>
		      </li>
		      
		      <li>
		      <%
				String BizGroSql = "SELECT * FROM project.bizareagroup";
		      	PreparedStatement BizGropstmt = conn.prepareStatement(BizGroSql);
		     	ResultSet BizGroRs = BizGropstmt.executeQuery();
		      %>
		        <a href="#">BizAreaGroup</a>
			        <ul class="submenu">
						<%
				     	 while(BizGroRs.next()){
				      	%>
						<li><a href="#"><%=BizGroRs.getString("BAG_Name") %></a></li>
				      	<%
				      	}
				      	%>
			        </ul>
		      </li>
		    </ul>
		</div>
		<div class="grid-container">
	        <div class="grid-item">
	            <canvas id="chart1"></canvas>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart2"></canvas>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart3"></canvas>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart4"></canvas>
	            <p>Chart 4</p>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart5"></canvas>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart6"></canvas>
	            <p>Chart 6</p>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart7"></canvas>
	            <p>Chart 7</p>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart8"></canvas>
	            <p>Chart 8</p>
	        </div>
	        <div class="grid-item">
	            <canvas id="chart9"></canvas>
	            <p>Chart 9</p>
	        </div>
    	</div>
	</div>
	<footer></footer>
</body>

</html>