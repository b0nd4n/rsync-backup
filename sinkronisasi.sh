# ============ sinkronisasi.sh 192.168.110.225 ==========

# ======================================
#!/bin/sh
# ==========================================
# VARIABEL TANGGAL & BASE PATH
# ==========================================
DATE_SUFFIX=$(date +%d-%m-%Y)

# ==== SERVER GL 10.2.5.5 ===
rsync -avz root@10.2.5.5:/mnt/data/sisko/{GLLOKAL,GL2008,VISGL} /data/duplikat/TEMPO/

# === SERVER SDM TEMPRINT ===
rsync -avz root@192.168.10.14:/data/Temprint/sdm/gjabs /data/duplikat/TEMPRINT/

# === SERVER APLIKASI TEMPRINT ===
rsync -avz root@192.168.110.31:/data1/apps/{databases,jamal,pths,sisjad} /data/duplikat/TEMPRINT/

# === SERVER APLIKASI BUDGET ===
rsync -avz root@192.168.110.32:/data1/apps/{@CBUDGET,@DBUDGET,@EBudget,@FBUDGET,@GBUDGET,@HBUDGET,@MBUDGET,@NBUDGET,@PBUDGET,@QBUDGET,@TBudget,@UBudget,@VBudget,@wBudget,@TVBudget} /data/duplikat/TEMPO/

# === SERVER APLIKASI KEUANGAN ===
# PJK_SIR perlu perlakuan khusus karena beda nama folder tujuan (#pjk_sir -> PJK_SIR)
rsync -avz root@192.168.110.34:/data1/apps/#pjk_sir/ /data/duplikat/TEMPO/PJK_SIR/

# Folder keuangan lainnya
rsync -avz root@192.168.110.34:/data1/apps/{@bapenas,@billing,@IKLAN_BARU,@IKLANLOKAL,@ikoran,@JURNAL_IKLAN,@markom,@miklan,@piu_tmp,@SIRKULASICETAK,@timi,CFB,Honorer,Inventori,INVOICE,Kas_Bank,Kwi.Manual,kwitansi,Kwitansilangganan,NBMK09,ncf_2009,NEWSIRKULASI,PRG21,SeriPajak,SIRKULASI,SLIP,SLIP_TPT} /data/duplikat/TEMPO/

# === SERVER APLIKASI SISKO & SISMA ===
rsync -avz root@192.168.110.35:/data1/apps/{MBM,SISKO} /data/duplikat/TEMPO/

chown -R root:root /data/duplikat/{TEMPO,TEMPRINT}
chmod -R 775 /data/duplikat/{TEMPO,TEMPRINT}
