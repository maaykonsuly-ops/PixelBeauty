@echo off
chcp 65001 >nul
echo ========================================================
echo   PIXELBEAUTY - ENVIAR PARA O GITHUB (maaykonsuly-ops)
echo ========================================================
echo.
echo Repositorio detectado: https://github.com/maaykonsuly-ops/PixelBeauty.git
echo.
echo Enviando o codigo para o GitHub...
echo (Se pedir login, confirme no navegador ou insira suas credenciais do GitHub)
echo.

"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" remote set-url origin https://github.com/maaykonsuly-ops/PixelBeauty.git 2>nul
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" branch -M main
"C:\Users\Maycon\Downloads\MinGit\cmd\git.exe" push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   SUCESSO! O CODIGO FOI ENVIADO!
    echo ========================================================
    echo Agora va no seu navegador em:
    echo https://github.com/maaykonsuly-ops/PixelBeauty/actions
    echo.
    echo 1. O build 'Build & Package iOS IPA' vai iniciar sozinho!
    echo 2. Aguarde cerca de 2 a 3 minutos
    echo 3. Quando terminar, baixe o 'PixelBeauty-Unsigned-IPA' na secao Artifacts!
    echo ========================================================
) else (
    echo.
    echo DICA: Se o push falhar por login, voce pode gerar um Personal Access Token
    echo no GitHub em Settings - Developer Settings - Personal Access Tokens
    echo ou simplesmente arrastar os arquivos na pagina do repositorio!
)

echo.
pause
