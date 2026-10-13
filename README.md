# 📱 PixelBeauty (AirBrush Alternative)

Um aplicativo iOS nativo desenvolvido em **SwiftUI** e **CoreImage/Vision** com as principais ferramentas do AirBrush, sem assinaturas nem mensalidades.

---

## ✨ Ferramentas Incluídas

1. **Beauty (Retoque de Pele)**:
   - Suavização de pele (Smooth) com preservação de detalhes
   - Clareamento de tom de pele (Skin Tone)
   - Realce de iluminação facial
2. **Maquiagem Virtual (Makeup)**:
   - Batom com paleta de cores (Vermelho, Rosa, Vinho, Coral, Nude) e ajuste de opacidade
   - Clareamento dental (Teeth Whitening)
   - Brilho nos olhos (Eye Brightening)
3. **Filtros (Artistic Filters)**:
   - Natural, Vivid, Warm, Cool, Fade Light, Fade Dark, Noir, Chrome
   - Controle deslizante de intensidade do filtro
4. **Ajustes Manuais**:
   - Brilho, Contraste, Saturação, Exposição, Nitidez e Efeito Vinheta
5. **Retocar Manchas (Blemish Remover)**:
   - Toque diretamente sobre manchas, espinhas ou marcas na tela para remover
6. **Reshape (Modelagem Facial)**:
   - Afinar rosto, aumentar olhos e afinar nariz
7. **Câmera & Galeria**:
   - Tirar foto com a câmera frontal/traseira ou importar da galeria de fotos
8. **Exportação**:
   - Salvar a imagem final tratada com alta resolução na galeria com 1 toque

---

## 🛠️ Como Gerar o Arquivo `.ipa` para o AltStore

Como o sistema operacional é Windows, a compilação do iOS é feita via **GitHub Actions** (100% gratuito e automatizado):

### Passo a Passo no GitHub Actions:
1. Crie um repositório no seu [GitHub](https://github.com) (pode ser público ou privado).
2. Suba a pasta deste projeto (`PixelBeauty`) para o repositório.
3. No GitHub, vá até a aba **Actions**.
4. Você verá o workflow **"Build Unsigned IPA for AltStore"**.
5. Clique em **Run workflow** (ou simplesmente faça um commit na branch `main`).
6. O GitHub rodará um servidor Mac na nuvem, compilará o app e criará o arquivo `PixelBeauty.ipa`.
7. Baixe o `PixelBeauty-Unsigned-IPA` na seção de artefatos da execução!

### Instalando pelo AltStore / Sideloadly:
1. Abra o **AltStore** ou **Sideloadly** no seu computador.
2. Conecte seu iPhone 13 via cabo USB ou Wi-Fi.
3. Arraste o arquivo `PixelBeauty.ipa` para dentro do AltStore/Sideloadly.
4. Digite seu Apple ID (para assinar o app localmente com seu certificado de desenvolvedor pessoal).
5. Pronto! O app aparecerá instalado na tela inicial do seu iPhone.
