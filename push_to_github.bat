@echo off
chcp 65001 >nul
echo ========================================================
echo   PIXELBEAUTY - ENVIAR PARA O GITHUB E GERAR O IPA
echo ========================================================
echo.
echo 1. Acesse https://github.com/new e crie um novo repositorio
echo    (Pode ser PUBLICO ou PRIVADO, sem README, sem .gitignore)
echo.
set /p REPO_URL="Cole a URL do seu repositorio GitHub aqui (ex: https://github.com/seu-usuario/PixelBeauty.git): "

if "%REPO_URL%"=="" (
    echo Erro: URL vazia!
    pause
    exit /b 1
)

echo.
echo Configurando remote origin...
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" remote remove origin 2>nul
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" remote add origin %REPO_URL%
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" branch -M main

echo Enviando codigo para o GitHub...
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   SUCESSO! O CODIGO FOI ENVIADO!
    echo ========================================================
    echo Agora abra seu repositorio no navegador:
    echo 1. Clique na aba 'Actions'
    echo 2. O build 'Build Unsigned IPA for AltStore' comecou!
    echo 3. Aguarde cerca de 2 a 3 minutos
    echo 4. Baixe o PixelBeauty-Unsigned-IPA na secao Artifacts!
    echo ========================================================
) else (
    echo.
    echo Ocorreu um erro no git push. Verifique se realizou login no GitHub ou se a URL esta correta.
)

echo.
pause
