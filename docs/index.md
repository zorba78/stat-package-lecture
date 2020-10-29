--- 
title: "통계 패키지 활용"
subtitle: "2020년도 2학기 충남대학교 정보통계학과 강의 노트"
author: "한국한의학연구원, 구본초"
date: "2020-10-30"
knit: "bookdown::render_book"
documentclass: krantz
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
colorlinks: yes
graphics: yes
lot: yes
lof: yes
fontsize: 11pt
description: "2020년도 2학기 정보통계학과 통계 프로그래밍 언어 강의 노트로 해당 노트는 https://zorba78.github.io/cnu-stat-package-lecture/ 에서 확인 가능"
site: bookdown::bookdown_site
github-repo: zorba78/cnu-r-programming-lecture-note
editor_options: 
  chunk_output_type: console
---







# Course Overview{-#overview}


R을 이용한 데이터 분석 시 CRAN에 등록된 패키지를 활용한다. 적절한 패키지의 활용은 데이터 분석의 효율을 증대할 뿐 아니라 분석의 재현성을 향상할 수 있다. 본 강의는 지난학기에 학습한 통계프로그래밍언어 강의 내용의 연속선 상에서 진행할 예정이며, 해당 강의에서 학습한 내용들을 기반으로 데이터 분석 및 그 결과에 대한 보고서 작성, 그리고 R 생성 파일에 대한 버전 관리 방법에 대해 알아보고자 한다.



#### 교과 목표{#purpose-course .unnumbered}

> - **R Markdown의 이해와 활용**
> - **R 프로그래밍 능력 향상 및 통계 시뮬레이션의 이해**
> - **R을 이용한 데이터 분석 실습**
> - **R을 이용한 기초 통계분석**
> - **텍스트 마이닝에 대한 이해**
> - **Shiny, plotly 를 활용한 동적 문서 및 시각화 이해**
> - **RStudio + Github을 이용한 버전관리 이해**


#### 선수과목{#pre-course .unnumbered}

> **통계학 개론**
> **통계 프로그래밍 언어**


#### 수업 방법{#course-method .unnumbered}

- **강의: 30 %**
- **실험/실습: 70 %**


#### 평가방법{#grade-method .unnumbered}

> - **중간고사: 35 %**
> - **기말고사: 35 %**
> - **출석: 10 %**
> - **과제: 20 %**


#### 교재{#material-course .unnumbered}

> 별도의 교재 없이 본 강의 노트로 수업을 진행할 예정이며, 수업의 이해도 향상을 위해 아래 소개할 도서 및 웹 문서 등을 참고할 것을 권장함.


#### 참고문헌{#ref-course .unnumbered}


- [R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) [@xie-2020]
- [bookdown: Authoring Books and Technical Documents with R Markdown](https://bookdown.org/yihui/bookdown/) [@xie-2016]
- R과 knitr를 활용한 데이터 연동형 문서 만들기 [@ko-2014]
- [R for data science](https://r4ds.had.co.nz/) [@wickham-2016r]
- Statistical Computing with R [@rizzo-2019]
- [R programming for data science](https://bookdown.org/rdpeng/rprogdatascience/) [@peng-2016]
- [Text mining with R](https://www.tidytextmining.com/) [@silge-2017]








