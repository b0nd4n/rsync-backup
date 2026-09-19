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
# 2. TEMPRINT
# ==========================================
echo "[1/8] Processing TEMPRINT..."

# Databases
DB_SRC="$SRC_BASE/TEMPRINT/databases"
DB_DEST="$DEST_BASE/temprint/databases_${DATE_SUFFIX}"
mkdir -p "$DB_DEST/log"

rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$DB_SRC/" "$DB_DEST/"
rsync $RSYNC_OPT --include='*.[aA][dD][iI]' --include='*.[aA][pP][pP]' --include='*.[cC][dD][xX]' --include='*.[dD][bB][cC]' \
                 --include='*.[dD][bB][fF]' --include='*.[dD][cC][tT]' --include='*.[eE][rR][rR]' --include='*.[fF][pP][tT]' \
                 --include='*.[fF][pP][wW]' --include='*.[fF][xX][pP]' --include='*.[dD][aA][tT]' --include='*.[tT][bB][kK]' \
                 --exclude='*' "$DB_SRC/log/" "$DB_DEST/log/"

# Jamal (01 s.d. 05)
JAMAL_SRC="$SRC_BASE/TEMPRINT/jamal"
JAMAL_DEST="$DEST_BASE/temprint/jamal_${DATE_SUFFIX}"
for i in $(seq -w 01 05); do
    mkdir -p "$JAMAL_DEST/$i"
    rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][aA][tT]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$JAMAL_SRC/$i/" "$JAMAL_DEST/$i/"
done

# PTHS
PTHS_SRC="$SRC_BASE/TEMPRINT/pths"
PTHS_DEST="$DEST_BASE/temprint/PTHS_${DATE_SUFFIX}"
mkdir -p "$PTHS_DEST/DATA/SISTEM"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[dD][lL][lL]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[fF][pP][wW]' --exclude='*' "$PTHS_SRC/" "$PTHS_DEST/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[dD][bB][fF]' --exclude='*' "$PTHS_SRC/DATA/" "$PTHS_DEST/DATA/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --exclude='*' "$PTHS_SRC/DATA/SISTEM/" "$PTHS_DEST/DATA/SISTEM/"

# GJABS
GJABS_SRC="$SRC_BASE/TEMPRINT/gjabs"
GJABS_DEST="$DEST_BASE/temprint/gjabs_${DATE_SUFFIX}"
mkdir -p "$GJABS_DEST/Pajak"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[cC][dD][xX]' --include='*.[fF][pP][tT]' --include='*.[dD][bB][cC]' --include='*.[fF][xX][pP]' --include='*.[dD][cC][tT]' --exclude='*' "$GJABS_SRC/" "$GJABS_DEST/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --exclude='*' "$GJABS_SRC/Pajak/" "$GJABS_DEST/Pajak/"

# SISJAD
SISJAD_SRC="$SRC_BASE/TEMPRINT/sisjad"
SISJAD_DEST="$DEST_BASE/temprint/SISJAD_${DATE_SUFFIX}"
mkdir -p "$SISJAD_DEST/Database/"{Import,Master,Payroll,Transaksi,User} "$SISJAD_DEST/ROP"
rsync $RSYNC_OPT --include='*.[dD][lL][lL]' --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[fF][pP][wW]' --exclude='*' "$SISJAD_SRC/" "$SISJAD_DEST/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[dD][bB][fF]' --include='*.[fF][rR][tT]' --include='*.[fF][rR][xX]' --include='*.[iI][dD][xX]' --exclude='*' "$SISJAD_SRC/Database/Import/" "$SISJAD_DEST/Database/Import/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --exclude='*' "$SISJAD_SRC/Database/Master/" "$SISJAD_DEST/Database/Master/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[cC][dD][xX]' --include='*.[dD][bB][cC]' --include='*.[dD][cC][tT]' --include='*.[fF][pP][tT]' --include='*.[iI][dD][xX]' --include='*.[tT][bB][kK]' --exclude='*' "$SISJAD_SRC/Database/Payroll/" "$SISJAD_DEST/Database/Payroll/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][aA][tT]' --exclude='*' "$SISJAD_SRC/Database/Transaksi/" "$SISJAD_DEST/Database/Transaksi/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[fF][pP][tT]' --exclude='*' "$SISJAD_SRC/Database/User/" "$SISJAD_DEST/Database/User/"

# ==========================================
# 3. IKLAN
# ==========================================
echo "[2/8] Processing IKLAN..."

IKLAN_DEST_BASE="$DEST_BASE/iklan"

# @bapenas & @billing
for item in "@bapenas" "@billing"; do
    dest="$IKLAN_DEST_BASE/${item}_${DATE_SUFFIX}/data"
    mkdir -p "$dest"
    rsync $RSYNC_OPT --include='*.[aA][dD][iI]' --include='*.[fF][pP][tT]' --include='*.[cC][dD][xX]' --include='*.[iI][nN][iI]' \
                     --include='*.[dD][bB][cC]' --include='*.[dD][bB][fF]' --include='*.[dD][cC][tT]' --include='*.[fF][xX][pP]' \
                     --include='*.[dD][aA][tT]' --include='*.[pP][rR][gG]' --exclude='*' \
                     "$SRC_BASE/TEMPO/$item/data/" "$dest/"
done

# @ikoran
IKORAN_DEST="$IKLAN_DEST_BASE/@ikoran_${DATE_SUFFIX}/DATA"
mkdir -p "$IKORAN_DEST/koran"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/@ikoran/DATA/" "$IKORAN_DEST/"
rsync $RSYNC_OPT --include='*.[kK][eE][uU]' --include='*.[fF][pP][wW]' --include='*.[iI][nN][iI]' --include='*.[fF][xX][pP]' \
                 --include='*.[pP][rR][gG]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[dD][aA][tT]' \
                 --include='*.[iI][dD][xX]' --include='*.[dD][lL][lL]' --exclude='*' \
                 "$SRC_BASE/TEMPO/@ikoran/DATA/koran/" "$IKORAN_DEST/koran/"

# @markom
MARKOM_DEST="$IKLAN_DEST_BASE/@markom_${DATE_SUFFIX}"
mkdir -p "$MARKOM_DEST/data"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][wW]' --include='*.[iI][nN][iI]' --include='*.[dD][aA][tT]' --include='*.[dD][lL][lL]' --exclude='*' \
                 "$SRC_BASE/TEMPO/@markom/" "$MARKOM_DEST/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' \
                 "$SRC_BASE/TEMPO/@markom/data/" "$MARKOM_DEST/data/"

# ==========================================
# 4. GL2008 & SERVER SISKO
# ==========================================
echo "[3/8] Processing GL2008 & SERVER SISKO..."

# GL2008
GL_SRC="$SRC_BASE/TEMPO/GL2008/DATA"
GL_DEST="$DEST_BASE/sisko/GL2008_${DATE_SUFFIX}/DATA"

mkdir -p "$GL_DEST/SISTEM"
for i in $(seq -w 01 18); do
    mkdir -p "$GL_DEST/GL$i/MASTER/TRANS"
done

rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[dD][bB][fF]' --exclude='*' "$GL_SRC/" "$GL_DEST/"
rsync $RSYNC_OPT --include='*.[dD][aA][tT]' --include='*.[dD][bB][fF]' --exclude='*' "$GL_SRC/SISTEM/" "$GL_DEST/SISTEM/"

for i in $(seq -w 01 18); do
    rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$GL_SRC/GL$i/MASTER/" "$GL_DEST/GL$i/MASTER/"
    rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$GL_SRC/GL$i/TRANS/" "$GL_DEST/GL$i/TRANS/"
done

# PJK_SIR
mkdir -p "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/DATA/PROSES"
rsync $RSYNC_OPT --include='*.[oO][cC][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[fF][rR][xX]' --include='*.[fF][rR][tT]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/PJK_SIR/" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/PJK_SIR/DATA/" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/DATA/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/PJK_SIR/DATA/PROSES/" "$DEST_BASE/sisko/PJK_SIR_${DATE_SUFFIX}/DATA/PROSES/"

# @piu_tmp
mkdir -p "$DEST_BASE/sisko/@piu_tmp_${DATE_SUFFIX}/data"
rsync $RSYNC_OPT --include='*.[oO][cC][xX]' --include='*.[dD][lL][lL]' --include='*.[dD][bB][fF]' --include='*.[fF][lL][lL]' --include='*.[fF][pP][tT]' --include='*.[fF][pP][wW]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/@piu_tmp/" "$DEST_BASE/sisko/@piu_tmp_${DATE_SUFFIX}/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[fF][xX][pP]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/@piu_tmp/data/" "$DEST_BASE/sisko/@piu_tmp_${DATE_SUFFIX}/data/"

# @timi
mkdir -p "$DEST_BASE/sisko/@timi_${DATE_SUFFIX}/data"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[xX][lL][sS]' --exclude='*' "$SRC_BASE/TEMPO/@timi/data/" "$DEST_BASE/sisko/@timi_${DATE_SUFFIX}/"

# INVOICE
mkdir -p "$DEST_BASE/sisko/INVOICE_${DATE_SUFFIX}"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/INVOICE/" "$DEST_BASE/sisko/INVOICE_${DATE_SUFFIX}/"

# Kas Bank
mkdir -p "$DEST_BASE/sisko/Kas_Bank_${DATE_SUFFIX}"
rsync $RSYNC_OPT --include='*.[dD][lL][lL]' --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[dD][cC][tT]' --include='*.[dD][cC][xX]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/Kas_Bank/" "$DEST_BASE/sisko/Kas_Bank_${DATE_SUFFIX}/"

# Kwitansi
mkdir -p "$DEST_BASE/sisko/kwitansi_${DATE_SUFFIX}"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/kwitansi/" "$DEST_BASE/sisko/kwitansi_${DATE_SUFFIX}/"

# Kwi Manual
mkdir -p "$DEST_BASE/sisko/Kwi.Manual_${DATE_SUFFIX}"
rsync $RSYNC_OPT "$SRC_BASE/TEMPO/Kwi.Manual/" "$DEST_BASE/sisko/Kwi.Manual_${DATE_SUFFIX}/"

# Kwitansi Langganan
mkdir -p "$DEST_BASE/sisko/Kwitansilangganan_${DATE_SUFFIX}"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/Kwitansilangganan/" "$DEST_BASE/sisko/Kwitansilangganan_${DATE_SUFFIX}/"

# PRG21
mkdir -p "$DEST_BASE/sisko/PRG21_${DATE_SUFFIX}/DATA/"{MASTER,SISTEM,TRANS}
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/PRG21/" "$DEST_BASE/sisko/PRG21_${DATE_SUFFIX}/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/PRG21/DATA/MASTER/" "$DEST_BASE/sisko/PRG21_${DATE_SUFFIX}/DATA/MASTER/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/PRG21/DATA/SISTEM/" "$DEST_BASE/sisko/PRG21_${DATE_SUFFIX}/DATA/SISTEM/"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/PRG21/DATA/TRANS/" "$DEST_BASE/sisko/PRG21_${DATE_SUFFIX}/DATA/TRANS/"

# SLIP
mkdir -p "$DEST_BASE/sisko/SLIP_${DATE_SUFFIX}/DATA"
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/SLIP/" "$DEST_BASE/sisko/SLIP_${DATE_SUFFIX}/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/SLIP/DATA/" "$DEST_BASE/sisko/SLIP_${DATE_SUFFIX}/DATA/"

# MBM
mkdir -p "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/"{MBM01/MASTER,MBM01/TRANS,MBM02/MASTER,MBM02/TRANS,MBM03/MASTER,MBM03/TRANS,SISTEM}
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --include='*.[fF][xX][pP]' --include='*.[pP][rR][gG]' --exclude='*' "$SRC_BASE/TEMPO/MBM/" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/"

for mbm in MBM01 MBM02 MBM03; do
    rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/MBM/DATA/$mbm/MASTER/" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/$mbm/MASTER/"
    rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[fF][pP][tT]' --exclude='*' "$SRC_BASE/TEMPO/MBM/DATA/$mbm/TRANS/" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/$mbm/TRANS/"
done
rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/MBM/DATA/SISTEM/" "$DEST_BASE/sisko/MBM_${DATE_SUFFIX}/DATA/SISTEM/"

# SISKO
mkdir -p "$DEST_BASE/sisko/SISKO_${DATE_SUFFIX}/DATA/TRS"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --include='*.[dD][aA][tT]' --exclude='*' "$SRC_BASE/TEMPO/SISKO/" "$DEST_BASE/sisko/SISKO_${DATE_SUFFIX}/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/SISKO/DATA/" "$DEST_BASE/sisko/SISKO_${DATE_SUFFIX}/DATA/"
rsync $RSYNC_OPT --include='*.[cC][dD][xX]' --include='*.[dD][bB][fF]' --exclude='*' "$SRC_BASE/TEMPO/SISKO/DATA/TRS/" "$DEST_BASE/sisko/SISKO_${DATE_SUFFIX}/DATA/TRS/"

# ==========================================
# 5. ANGGARAN (BUDGETS)
# ==========================================
echo "[4/8] Processing ANGGARAN..."

BUDGET_MODULES=("@CBUDGET" "@DBUDGET" "@EBudget" "@FBUDGET" "@GBUDGET" "@HBUDGET" "@MBUDGET" "@NBUDGET" "@PBUDGET" "@QBUDGET" "@TBudget" "@TVBudget" "@UBudget" "@VBudget" "@dkBudget" "@rpBudget" "@wBudget")
for mod in "${BUDGET_MODULES[@]}"; do
    mod_dest="$IKLAN_DEST_BASE/${mod}_${DATE_SUFFIX}"
    for yr in {2021..2026}; do
        mkdir -p "$mod_dest/dtang/$yr"
        rsync $RSYNC_OPT --include='*.[dD][bB][fF]' --include='*.[cC][dD][xX]' --include='*.[dD][aA][tT]' --exclude='*' \
                         "$SRC_BASE/TEMPO/$mod/dtang/$yr/" "$mod_dest/dtang/$yr/"
    done
done

# ==========================================
# 6. COMPRESSING ARCHIVES
# ==========================================
echo "[5/8] Compressing backups into $COMPRESS_BASE..."

# TEMPRINT
TEMPRINT_ITEMS=("databases:databases" "gjabs:gjabs" "jamal:jamal" "pths:PTHS" "sisjad:SISJAD")
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
IKLAN_ONLY_ITEMS=("@bapenas" "@billing" "@ikoran" "@markom")
for item in "${IKLAN_ONLY_ITEMS[@]}"; do
    if [ -d "$DEST_BASE/iklan/${item}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$item"
        tar -czvf "$COMPRESS_BASE/$item/${item}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/iklan" "${item}_${DATE_SUFFIX}"
    fi
done

# IKLAN-KEUANGAN (Source from /data/backup/sisko)
KEUANGAN_SISKO_ITEMS=("INVOICE:INVOICE:INVOICE" "Kas_Bank:Kas_Bank:Kas_Bank" "Kwi.Manual:Kwi.Manual:Kwi_Manual" "kwitansi:kwitansi:kwitansi" "Kwitansilangganan:Kwitansilangganan:Kwitansilangganan" "@piu_tmp:@piu_tmp:@piu_tmp" "@timi:@timi:@timi" "PJK_SIR:PJK_SIR:PJK_SIR" "PRG21:PRG21:PRG21" "SLIP:SLIP:SLIP")
for item in "${KEUANGAN_SISKO_ITEMS[@]}"; do
    IFS=":" read -r target_dir src_dir file_prefix <<< "$item"
    if [ -d "$DEST_BASE/sisko/${src_dir}_${DATE_SUFFIX}" ]; then
        mkdir -p "$COMPRESS_BASE/$target_dir"
        tar -czvf "$COMPRESS_BASE/$target_dir/${file_prefix}_${DATE_SUFFIX}.tar.gz" \
            -C "$DEST_BASE/sisko" "${src_dir}_${DATE_SUFFIX}"
    fi
done

# SISKO-SISMA
SISKO_ITEMS=("MBM:MBM:MBM" "SISKO:SISKO:SISKO")
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
ALL_KEUANGAN_LIST=("@bapenas" "@billing" "@ikoran" "@markom" "INVOICE" "Kas_Bank" "Kwi.Manual" "kwitansi" "Kwitansilangganan" "@piu_tmp" "@timi" "PJK_SIR" "PRG21" "SLIP")
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
SISMA_LIST=("MBM" "SISKO")
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

# Hapus folder backup mentah di /data/backup/ yang lebih dari 3 hari
find "$DEST_BASE" -mindepth 2 -maxdepth 2 -type d -mtime +3 -exec rm -rf {} \;

# Hapus .tar.gz yang lebih dari 7 hari
find "$COMPRESS_BASE" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;

# Hapus log lama yang lebih dari 7 hari
find "$LOG_DIR" -type f -name "backup_*.log" -mtime +7 -exec rm -f {} \;

# Hapus folder kosong di kompresi jika ada
find "$COMPRESS_BASE" -mindepth 1 -type d -empty -delete

# ==========================================
# 9. FINISH
# ==========================================
echo "=================================================="
echo "BACKUP PROCESS COMPLETED SUCCESSFULLY: $(date)"
echo "=================================================="

# ====== PUSH TO GITHUB ==========
