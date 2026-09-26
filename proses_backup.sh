#!/bin/bash

# ==========================================
# 1. KONFIGURASI PATH & LOGGING
# ==========================================
DATE_SUFFIX=$(date +%d-%m-%Y)
YEAR=$(date +%Y)
MONTH_DIR=$(date +%m-%B) # Hasil contoh: "01-January", "02-February", dst.

SRC_BASE="/data/duplikat"
DEST_BASE="/data/backup"
COMPRESS_BASE="/data/kompres"
LOG_DIR="/data/logs"
SYNOLOGY_BASE="/synologi_105/Backup_SIU"

# Buat folder log jika belum ada
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup_${DATE_SUFFIX}.log"

# Arahkan seluruh Standard Output (STDOUT) & Error (STDERR) ke File Log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=================================================="
echo "START BACKUP PROCESS: $(date)"
echo "=================================================="

RSYNC_OPT="-avz"

# ==========================================
# FUNGSI PEMBANTU RSYNC (CENTRAL EXTENSION FILTER)
# ==========================================
# Seluruh filter ekstensi terpusat di sini
sync_ext() {
    local src_path="$1"
    local dest_path="$2"
    mkdir -p "$dest_path"
    rsync $RSYNC_OPT \
        --include='*.[aA][dD][iI]' \
        --include='*.[cC][dD][xX]' \
        --include='*.[dD][bB][fF]' \
        --include='*.[dD][aA][tT]' \
        --include='*.[dD][cC][tT]' \
        --include='*.[dD][cC][xX]' \
        --exclude='*' \
        "$src_path/" "$dest_path/"
}

# ==========================================
# 2. TEMPRINT
# ==========================================
echo "[1/8] Processing TEMPRINT..."

# 1. DATABASES
for sub in "" "/log"; do
    sync_ext "$SRC_BASE/TEMPRINT/databases$sub" "$DEST_BASE/temprint/databases_${DATE_SUFFIX}$sub"
done

# 2. JAMAL
sync_ext "$SRC_BASE/TEMPRINT/jamal" "$DEST_BASE/temprint/jamal_${DATE_SUFFIX}"
for i in $(seq -w 01 05); do
    sync_ext "$SRC_BASE/TEMPRINT/jamal/$i" "$DEST_BASE/temprint/jamal_${DATE_SUFFIX}/$i"
done

# 3. PTHS
for sub in "" "/DATA"; do
    sync_ext "$SRC_BASE/TEMPRINT/pths$sub" "$DEST_BASE/temprint/pths_${DATE_SUFFIX}$sub"
done

# 4. SISJAD
for sub in "" "/Database" "/Database/Payroll"; do
    sync_ext "$SRC_BASE/TEMPRINT/sisjad$sub" "$DEST_BASE/temprint/sisjad_${DATE_SUFFIX}$sub"
done

# 5. GJABS
sync_ext "$SRC_BASE/TEMPRINT/gjabs" "$DEST_BASE/temprint/gjabs_${DATE_SUFFIX}"

# ==========================================
# 3. IKLAN
# ==========================================
echo "[2/8] Processing IKLAN..."

IKLAN_DEST_BASE="$DEST_BASE/iklan"

# @billing & @piu_tmp
for item in "@billing" "@piu_tmp"; do
    sync_ext "$SRC_BASE/TEMPO/$item/data" "$IKLAN_DEST_BASE/${item}_${DATE_SUFFIX}/data"
done

# ==========================================
# 4. GL2008 & SERVER SISKO
# ==========================================
echo "[3/8] Processing GL2008 & SERVER SISKO..."

# GL2008
GL_SRC="$SRC_BASE/TEMPO/GL2008/DATA"
GL_DEST="$DEST_BASE/sisko/GL2008_${DATE_SUFFIX}/DATA"

sync_ext "$GL_SRC" "$GL_DEST"
sync_ext "$GL_SRC/SISTEM" "$GL_DEST/SISTEM"

for i in $(seq -w 01 18); do
    sync_ext "$GL_SRC/GL$i/MASTER" "$GL_DEST/GL$i/MASTER"
    sync_ext "$GL_SRC/GL$i/TRANS" "$GL_DEST/GL$i/TRANS"
done

# PJK_SIR
sync_ext "$SRC_BASE/TEMPO/PJK_SIR" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}"
sync_ext "$SRC_BASE/TEMPO/PJK_SIR/DATA" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/DATA"
sync_ext "$SRC_BASE/TEMPO/PJK_SIR/DATA/PROSES" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/DATA/PROSES"

# INVOICE
sync_ext "$SRC_BASE/TEMPO/INVOICE" "$DEST_BASE/sisko/INVOICE_${DATE_SUFFIX}"

# Kas Bank
sync_ext "$SRC_BASE/TEMPO/Kas_Bank" "$DEST_BASE/sisko/Kas_Bank_${DATE_SUFFIX}"

# Kwitansi Langganan
sync_ext "$SRC_BASE/TEMPO/Kwitansilangganan" "$DEST_BASE/sisko/Kwitansilangganan_${DATE_SUFFIX}"

# MBM
sync_ext "$SRC_BASE/TEMPO/MBM" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}"
for mbm in MBM01 MBM02 MBM03; do
    sync_ext "$SRC_BASE/TEMPO/MBM/DATA/$mbm/MASTER" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/$mbm/MASTER"
    sync_ext "$SRC_BASE/TEMPO/MBM/DATA/$mbm/TRANS" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/$mbm/TRANS"
done
sync_ext "$SRC_BASE/TEMPO/MBM/DATA/SISTEM" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/SISTEM"

# ==========================================
# 5. ANGGARAN (BUDGETS)
# ==========================================
echo "[4/8] Processing ANGGARAN..."

BUDGET_MODULES=("@CBUDGET" "@DBUDGET" "@EBudget" "@FBUDGET" "@GBUDGET" "@HBUDGET" "@MBUDGET" "@NBUDGET" "@PBUDGET" "@QBUDGET" "@TBudget" "@TVBudget" "@UBudget" "@VBudget" "@dkBudget" "@rpBudget" "@wBudget")
for mod in "${BUDGET_MODULES[@]}"; do
    mod_dest="$IKLAN_DEST_BASE/${mod}_${DATE_SUFFIX}"
    for yr in {2021..2026}; do
        sync_ext "$SRC_BASE/TEMPO/$mod/dtang/$yr" "$mod_dest/dtang/$yr"
    done
done

# ==========================================
# 6. COMPRESSING ARCHIVES
# ==========================================
echo "[5/8] Compressing backups into $COMPRESS_BASE..."

# TEMPRINT
TEMPRINT_ITEMS=("databases:databases" "gjabs:gjabs" "jamal:jamal" "pths:pths" "sisjad:sisjad")
for item in "${TEMPRINT_ITEMS[@]}"; do
    target_dir="${item%%:*}"
    src_dir="${item##*:}"
    if [ -d "$DEST_BASE/temprint/${src_dir}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$target_dir"
        tar -czvf "$COMPRESS_BASE/$target_dir/${target_dir}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/temprint" "${src_dir}_${DATE_SUFFIX}"
    fi
done

# ANGGARAN
BUDGET_ITEMS=("@CBUDGET" "@DBUDGET" "@EBudget" "@FBUDGET" "@GBUDGET" "@HBUDGET" "@MBUDGET" "@NBUDGET" "@PBUDGET" "@QBUDGET" "@TBudget" "@TVBudget" "@UBudget" "@VBudget" "@dkBudget" "@rpBudget" "@wBudget")
for item in "${BUDGET_ITEMS[@]}"; do
    if [ -d "$DEST_BASE/iklan/${item}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$item"
        tar -czvf "$COMPRESS_BASE/$item/${item}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/iklan" "${item}_${DATE_SUFFIX}"
    fi
done

# IKLAN (Direct from /data/backup/iklan)
IKLAN_ONLY_ITEMS=("@billing" "@piu_tmp")
for item in "${IKLAN_ONLY_ITEMS[@]}"; do
    if [ -d "$DEST_BASE/iklan/${item}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$item"
        tar -czvf "$COMPRESS_BASE/$item/${item}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/iklan" "${item}_${DATE_SUFFIX}"
    fi
done

# IKLAN-KEUANGAN (Source from /data/backup/sisko)
KEUANGAN_SISKO_ITEMS=("INVOICE:INVOICE:INVOICE" "Kas_Bank:Kas_Bank:Kas_Bank" "Kwitansilangganan:Kwitansilangganan:Kwitansilangganan" "PJK_SIR:PJK_SIR:PJK_SIR")
for item in "${KEUANGAN_SISKO_ITEMS[@]}"; do
    IFS=":" read -r target_dir src_dir file_prefix <<< "$item"
    if [ -d "$DEST_BASE/sisko/${src_dir}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$target_dir"
        tar -czvf "$COMPRESS_BASE/$target_dir/${file_prefix}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/sisko" "${src_dir}_${DATE_SUFFIX}"
    fi
done

# SISKO-SISMA
SISKO_ITEMS=("MBM:MBM:MBM")
for item in "${SISKO_ITEMS[@]}"; do
    IFS=":" read -r target_dir src_dir file_prefix <<< "$item"
    if [ -d "$DEST_BASE/sisko/${src_dir}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$target_dir"
        tar -czvf "$COMPRESS_BASE/$target_dir/${file_prefix}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/sisko" "${src_dir}_${DATE_SUFFIX}"
    fi
done

# GL2008 (Fixed Path: reading from /data/backup/sisko)
if [ -d "$DEST_BASE/sisko/GL2008_${DATE_SUFFIX}" ]; then
    mkdir -p "$COMPRESS_BASE/GL2008"
    tar -czvf "$COMPRESS_BASE/GL2008/GL2008_${DATE_SUFFIX}.tar.gz" \
        -C "$DEST_BASE/sisko" "GL2008_${DATE_SUFFIX}"
fi

# ==========================================
# 7. RSYNC KOMPRES KE SYNOLOGY
# ==========================================
echo "[6/8] Syncing compressed archives to Synology ($YEAR/$MONTH_DIR)..."

# --- 7a. ANGGARAN ---
for item in "${BUDGET_ITEMS[@]}"; do
    if [ -d "$COMPRESS_BASE/$item" ]; then
        target_synology_dir="$SYNOLOGY_BASE/ANGGARAN/$item/$YEAR/$MONTH_DIR"
        mkdir -p "$target_synology_dir"
        rsync $RSYNC_OPT "$COMPRESS_BASE/$item/" "$target_synology_dir/"
    fi
done

# --- 7b. IKLAN-KEUANGAN ---
ALL_KEUANGAN_LIST=("@billing" "INVOICE" "Kas_Bank" "Kwitansilangganan" "@piu_tmp" "PJK_SIR")
for item in "${ALL_KEUANGAN_LIST[@]}"; do
    if [ -d "$COMPRESS_BASE/$item" ]; then
        target_dir="$SYNOLOGY_BASE/IKLAN-KEUANGAN/$item/$YEAR/$MONTH_DIR"
        mkdir -p "$target_dir"
        rsync $RSYNC_OPT "$COMPRESS_BASE/$item/" "$target_dir/"
    fi
done

# --- 7c. GL ---
if [ -d "$COMPRESS_BASE/GL2008" ]; then
    target_dir="$SYNOLOGY_BASE/GL/GL2008/$YEAR/$MONTH_DIR"
    mkdir -p "$target_dir"
    rsync $RSYNC_OPT "$COMPRESS_BASE/GL2008/" "$target_dir/"
fi

# --- 7d. TEMPRINT ---
TEMPRINT_LIST=("databases" "gjabs" "jamal" "pths" "sisjad")
for item in "${TEMPRINT_LIST[@]}"; do
    if [ -d "$COMPRESS_BASE/$item" ]; then
        target_dir="$SYNOLOGY_BASE/Temprint/$item/$YEAR/$MONTH_DIR"
        mkdir -p "$target_dir"
        rsync $RSYNC_OPT "$COMPRESS_BASE/$item/" "$target_dir/"
    fi
done

# --- 7e. SISKO-SISMA ---
SISMA_LIST=("MBM")
for item in "${SISMA_LIST[@]}"; do
    if [ -d "$COMPRESS_BASE/$item" ]; then
        target_dir="$SYNOLOGY_BASE/SISKO-SISMA/$item/$YEAR/$MONTH_DIR"
        mkdir -p "$target_dir"
        rsync $RSYNC_OPT "$COMPRESS_BASE/$item/" "$target_dir/"
    fi
done

# ==========================================
# 8. PURGE OLD BACKUPS & LOGS
# ==========================================
echo "[7/8] Purging backups and logs older than 7 days..."

# Hapus folder backup mentah di /data/backup/ yang lebih dari 1 hari, KECUALIKAN hari ini
find "$DEST_BASE" -mindepth 2 -maxdepth 2 -type d ! -name "*_${DATE_SUFFIX}*" -mtime +1 -exec rm -rf {} \;

# Hapus .tar.gz yang lebih dari 7 hari
find "$COMPRESS_BASE" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;

# Hapus log lama yang lebih dari 7 hari
find "$LOG_DIR" -type f -name "backup_*.log" -mtime +7 -exec rm -f {} \;
find "$LOG_DIR" -type f -name "sinkronisasi_*.log" -mtime +7 -exec rm -f {} \;

# Hapus folder kosong di kompresi jika ada
find "$COMPRESS_BASE" -mindepth 1 -type d -empty -delete

# ==========================================
# 9. FINISH
# ==========================================
echo "=================================================="
echo "BACKUP PROCESS COMPLETED SUCCESSFULLY: $(date)"
echo "=================================================="

