@echo off
setlocal EnableDelayedExpansion

echo ======================================================================
echo   SMART BOOKING PLATFORM - WORKFLOW: CHECKOUT - COMMIT - MERGE MAIN
echo ======================================================================
echo.

set "BRANCH_NAME=fix/common-compile-models"

echo [1/5] Dang tao va chuyen sang nhanh rieng: %BRANCH_NAME% ...
git checkout -b %BRANCH_NAME% 2>nul
if %ERRORLEVEL% neq 0 (
    echo Nhanh %BRANCH_NAME% da ton tai, chuyen sang nhanh do...
    git checkout %BRANCH_NAME%
)

echo.
echo [2/5] Staging cac file thay doi...
git add src/java/com/project/model/*.java
git add src/java/com/project/dao/*.java
git add src/java/com/project/util/EmailUtil.java
git add src/java/com/project/controller/admin/AdminUserController.java
git add web/WEB-INF/views/customer/booking-detail.jsp
git add build_check.bat
git add AGENTS.md
git add GIT_COMMIT_RULES.md
git add build.xml

echo.
echo [3/5] Dang commit tren nhanh %BRANCH_NAME% ...
git commit -m "fix(common): bo sung model, dao, util va fix loi bien dich NetBeans 0 error"

if %ERRORLEVEL% neq 0 (
    echo [THONG BAO] Khong co file thay doi hoac da duoc commit truoc do.
)

echo.
echo [4/5] Chuyen ve nhanh main va merge %BRANCH_NAME% vao main...
git checkout main
if %ERRORLEVEL% neq 0 (
    echo [LOI] Khong the checkout ve main. Vui long kiem tra lai git branch!
    pause
    exit /b 1
)

git merge --no-ff %BRANCH_NAME% -m "Merge branch '%BRANCH_NAME%' into main"

echo.
echo [5/5] Xoa nhanh tam sau khi da merge...
git branch -d %BRANCH_NAME%

echo.
echo ======================================================================
echo   HOAN TAT WORKFLOW: CHECKOUT -> COMMIT -> MERGE MAIN -> CLEANUP!
echo ======================================================================
echo.
git status
echo.
pause
