#!/usr/bin/env bash
# Configuration de l'environnement de développement mobile Flutter sur Ubuntu natif.
set -euo pipefail

# ─── Constantes ────────────────────────────────────────────────────────────────

FLUTTER_VERSION="3.44.0"
FLUTTER_CHANNEL="stable"
FLUTTER_INSTALL_DIR="${HOME}/flutter"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"

ANDROID_HOME="${HOME}/Android/Sdk"
CMDLINE_TOOLS_VERSION="latest"
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
CMDLINE_TOOLS_DIR="${ANDROID_HOME}/cmdline-tools/${CMDLINE_TOOLS_VERSION}"

ANDROID_PLATFORM="android-36"
BUILD_TOOLS_VERSION="36.0.0"

BASHRC="${HOME}/.bashrc"
ENV_MARKER="# >>> Séléné mobile env >>>"
ENV_MARKER_END="# <<< Séléné mobile env <<<"

# ─── Couleurs ──────────────────────────────────────────────────────────────────

VERT='\033[0;32m'
BLEU='\033[0;34m'
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
RESET='\033[0m'

etape()  { echo -e "\n${BLEU}▶ $*${RESET}"; }
ok()     { echo -e "  ${VERT}✓ $*${RESET}"; }
info()   { echo -e "  ${JAUNE}• $*${RESET}"; }
erreur() { echo -e "  ${ROUGE}✗ $*${RESET}" >&2; }

# ─── Utilitaires ───────────────────────────────────────────────────────────────

commande_existe() { command -v "$1" &>/dev/null; }

bloc_env_present() {
    grep -qF "${ENV_MARKER}" "${BASHRC}" 2>/dev/null
}

ajouter_bloc_env() {
    # Idempotent : n'insère le bloc qu'une seule fois
    if bloc_env_present; then
        info "Bloc variables d'environnement déjà présent dans ${BASHRC}"
        return
    fi

    cat >> "${BASHRC}" <<EOF

${ENV_MARKER}
export ANDROID_HOME="${ANDROID_HOME}"
export PATH="\${PATH}:${FLUTTER_INSTALL_DIR}/bin"
export PATH="\${PATH}:\${ANDROID_HOME}/cmdline-tools/${CMDLINE_TOOLS_VERSION}/bin"
export PATH="\${PATH}:\${ANDROID_HOME}/platform-tools"
export PATH="\${PATH}:\${ANDROID_HOME}/build-tools/${BUILD_TOOLS_VERSION}"
${ENV_MARKER_END}
EOF
    ok "Bloc variables d'environnement ajouté dans ${BASHRC}"
}

# Recharge le PATH courant sans sourcer ~/.bashrc (évite les effets de bord)
recharger_path() {
    export ANDROID_HOME="${ANDROID_HOME}"
    export PATH="${PATH}:${FLUTTER_INSTALL_DIR}/bin"
    export PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/${CMDLINE_TOOLS_VERSION}/bin"
    export PATH="${PATH}:${ANDROID_HOME}/platform-tools"
    export PATH="${PATH}:${ANDROID_HOME}/build-tools/${BUILD_TOOLS_VERSION}"
}

# ─── Vérifications préalables ──────────────────────────────────────────────────

verifier_dependances() {
    etape "Vérification des dépendances système"

    local manquants=()
    for pkg in curl wget unzip tar xz-utils git openjdk-17-jdk; do
        if ! dpkg -l "$pkg" &>/dev/null 2>&1; then
            manquants+=("$pkg")
        fi
    done

    if [[ ${#manquants[@]} -gt 0 ]]; then
        info "Installation des dépendances manquantes : ${manquants[*]}"
        sudo apt-get update -qq
        sudo apt-get install -y "${manquants[@]}"
    fi

    ok "Dépendances système présentes"
}

# ─── Étape 1 : Flutter ─────────────────────────────────────────────────────────

installer_flutter() {
    etape "Flutter ${FLUTTER_VERSION}"

    if [[ -d "${FLUTTER_INSTALL_DIR}" ]]; then
        local version_actuelle
        version_actuelle="$("${FLUTTER_INSTALL_DIR}/bin/flutter" --version 2>/dev/null | awk '/^Flutter/ {print $2}' || echo "inconnue")"
        if [[ "${version_actuelle}" == "${FLUTTER_VERSION}" ]]; then
            ok "Flutter ${FLUTTER_VERSION} déjà installé dans ${FLUTTER_INSTALL_DIR}"
            return
        else
            info "Version détectée : ${version_actuelle} — remplacement par ${FLUTTER_VERSION}"
            rm -rf "${FLUTTER_INSTALL_DIR}"
        fi
    fi

    local archive="/tmp/flutter_${FLUTTER_VERSION}.tar.xz"

    if [[ ! -f "${archive}" ]]; then
        info "Téléchargement de Flutter ${FLUTTER_VERSION}…"
        curl -fL --progress-bar "${FLUTTER_SDK_URL}" -o "${archive}"
    else
        info "Archive déjà présente dans /tmp, extraction directe"
    fi

    info "Extraction vers ${HOME}…"
    tar -xf "${archive}" -C "${HOME}"

    ok "Flutter ${FLUTTER_VERSION} installé dans ${FLUTTER_INSTALL_DIR}"
}

# ─── Étape 2 : Android SDK ─────────────────────────────────────────────────────

installer_android_sdk() {
    etape "Android SDK — cmdline-tools"

    mkdir -p "${ANDROID_HOME}"

    if [[ -f "${CMDLINE_TOOLS_DIR}/bin/sdkmanager" ]]; then
        ok "cmdline-tools déjà présents dans ${CMDLINE_TOOLS_DIR}"
    else
        local archive="/tmp/cmdline-tools-android.zip"

        if [[ ! -f "${archive}" ]]; then
            info "Téléchargement des cmdline-tools…"
            curl -fL --progress-bar "${CMDLINE_TOOLS_URL}" -o "${archive}"
        else
            info "Archive cmdline-tools déjà présente dans /tmp"
        fi

        info "Extraction des cmdline-tools…"
        local tmp_extract
        tmp_extract="$(mktemp -d)"
        unzip -q "${archive}" -d "${tmp_extract}"

        # Le zip contient un dossier 'cmdline-tools' à renommer en 'latest'
        mkdir -p "$(dirname "${CMDLINE_TOOLS_DIR}")"
        mv "${tmp_extract}/cmdline-tools" "${CMDLINE_TOOLS_DIR}"
        rm -rf "${tmp_extract}"

        ok "cmdline-tools installés dans ${CMDLINE_TOOLS_DIR}"
    fi

    recharger_path

    etape "Android SDK — platform-tools + platform + build-tools"

    local sdkmanager="${CMDLINE_TOOLS_DIR}/bin/sdkmanager"

    local paquets_a_installer=()

    if [[ ! -d "${ANDROID_HOME}/platform-tools" ]]; then
        paquets_a_installer+=("platform-tools")
    else
        ok "platform-tools déjà installés"
    fi

    if [[ ! -d "${ANDROID_HOME}/platforms/${ANDROID_PLATFORM}" ]]; then
        paquets_a_installer+=("platforms;${ANDROID_PLATFORM}")
    else
        ok "platforms;${ANDROID_PLATFORM} déjà installé"
    fi

    if [[ ! -d "${ANDROID_HOME}/build-tools/${BUILD_TOOLS_VERSION}" ]]; then
        paquets_a_installer+=("build-tools;${BUILD_TOOLS_VERSION}")
    else
        ok "build-tools;${BUILD_TOOLS_VERSION} déjà installés"
    fi

    if [[ ${#paquets_a_installer[@]} -gt 0 ]]; then
        info "Installation : ${paquets_a_installer[*]}"
        yes | "${sdkmanager}" --sdk_root="${ANDROID_HOME}" "${paquets_a_installer[@]}"
        ok "Paquets Android SDK installés"
    fi
}

# ─── Étape 3 : Licences Android ────────────────────────────────────────────────

accepter_licences() {
    etape "Licences Android SDK"

    local sdkmanager="${CMDLINE_TOOLS_DIR}/bin/sdkmanager"

    yes | "${sdkmanager}" --sdk_root="${ANDROID_HOME}" --licenses > /dev/null 2>&1 || true
    ok "Licences Android SDK acceptées"
}

# ─── Étape 4 : Chromium ────────────────────────────────────────────────────────

installer_chromium() {
    etape "Chromium (requis pour flutter build web)"

    if commande_existe chromium-browser || commande_existe chromium || commande_existe google-chrome; then
        ok "Navigateur Chromium/Chrome déjà installé"
    else
        info "Installation de Chromium…"
        sudo apt-get update -qq
        sudo apt-get install -y chromium-browser
        ok "Chromium installé"
    fi
}

# ─── Étape 5 : CHROME_EXECUTABLE ──────────────────────────────────────────────

configurer_chrome_executable() {
    etape "CHROME_EXECUTABLE"

    local chrome_path=""

    for candidat in \
        "$(command -v chromium-browser 2>/dev/null)" \
        "$(command -v chromium 2>/dev/null)" \
        "$(command -v google-chrome 2>/dev/null)" \
        "/usr/bin/chromium-browser" \
        "/usr/bin/chromium" \
        "/usr/bin/google-chrome"; do
        if [[ -n "${candidat}" && -x "${candidat}" ]]; then
            chrome_path="${candidat}"
            break
        fi
    done

    if [[ -z "${chrome_path}" ]]; then
        erreur "Aucun navigateur Chromium/Chrome trouvé — CHROME_EXECUTABLE non configuré"
        return 1
    fi

    # Ajouter CHROME_EXECUTABLE dans le bloc env si absent
    if grep -qF "CHROME_EXECUTABLE" "${BASHRC}" 2>/dev/null; then
        info "CHROME_EXECUTABLE déjà défini dans ${BASHRC}"
    else
        # Insérer avant la balise de fermeture du bloc
        sed -i "s|${ENV_MARKER_END}|export CHROME_EXECUTABLE=\"${chrome_path}\"\n${ENV_MARKER_END}|" "${BASHRC}"
        ok "CHROME_EXECUTABLE=${chrome_path} ajouté dans ${BASHRC}"
    fi

    export CHROME_EXECUTABLE="${chrome_path}"
    ok "CHROME_EXECUTABLE=${chrome_path}"
}

# ─── Étape 6 : Variables d'environnement ──────────────────────────────────────

configurer_variables_env() {
    etape "Variables d'environnement dans ${BASHRC}"
    ajouter_bloc_env
    recharger_path
}

# ─── Étape 7 : Vérification flutter doctor ────────────────────────────────────

verifier_flutter_doctor() {
    etape "flutter doctor"
    "${FLUTTER_INSTALL_DIR}/bin/flutter" doctor --android-licenses < /dev/null > /dev/null 2>&1 || true
    "${FLUTTER_INSTALL_DIR}/bin/flutter" doctor -v
}

# ─── Résumé final ──────────────────────────────────────────────────────────────

afficher_resume() {
    echo ""
    echo -e "${VERT}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${VERT}║        Environnement mobile configuré        ║${RESET}"
    echo -e "${VERT}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  Flutter       : ${FLUTTER_INSTALL_DIR}/bin/flutter"
    echo -e "  Android SDK   : ${ANDROID_HOME}"
    echo -e "  Platform      : ${ANDROID_PLATFORM}"
    echo -e "  Build tools   : ${BUILD_TOOLS_VERSION}"
    echo -e "  Chrome        : ${CHROME_EXECUTABLE:-non défini}"
    echo ""
    echo -e "  ${JAUNE}Rechargez votre shell pour activer les variables :${RESET}"
    echo -e "  ${JAUNE}source ~/.bashrc${RESET}"
    echo ""
}

# ─── Point d'entrée ────────────────────────────────────────────────────────────

main() {
    echo -e "${BLEU}════════════════════════════════════════════════${RESET}"
    echo -e "${BLEU}  Séléné — Setup environnement mobile Flutter   ${RESET}"
    echo -e "${BLEU}════════════════════════════════════════════════${RESET}"

    verifier_dependances
    configurer_variables_env
    installer_flutter
    installer_android_sdk
    accepter_licences
    installer_chromium
    configurer_chrome_executable
    verifier_flutter_doctor
    afficher_resume
}

main "$@"
