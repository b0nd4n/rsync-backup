# ============ sinkronisasi.sh 192.168.110.225 ==========

# ======================================
#!/bin/sh
# ==========================================
# VARIABEL TANGGAL & BASE PATH
# ==========================================
DATE_SUFFIX=$(date +%d-%m-%Y)

rsync -avz root@10.2.5.5:/mnt/data/sisko/GLLOKAL /data/duplikat/TEMPO/
rsync -avz root@10.2.5.5:/mnt/data/sisko/GL2008 /data/duplikat/TEMPO/
rsync -avz root@10.2.5.5:/mnt/data/sisko/VISGL /data/duplikat/TEMPO/

rsync -avz root@192.168.10.14:/data/Temprint/sdm/gjabs /data/duplikat/TEMPRINT/
#rsync -avz root@192.168.10.14:/data/Temprint/sdm/@sisgalur /data/duplikat/TEMPRINT/

#rsync -avz root@192.168.110.31:/data1/apps/@tini /data/duplikat/TEMPRINT/
rsync -avz root@192.168.110.31:/data1/apps/databases /data/duplikat/TEMPRINT/
rsync -avz root@192.168.110.31:/data1/apps/jamal /data/duplikat/TEMPRINT/
rsync -avz root@192.168.110.31:/data1/apps/pths /data/duplikat/TEMPRINT/
rsync -avz root@192.168.110.31:/data1/apps/sisjad /data/duplikat/TEMPRINT/
#

##04-08-2021
#rsync -avz root@192.168.110.32:/data1/apps/@budget /data/duplikat/TEMPO/
##
rsync -avz root@192.168.110.32:/data1/apps/@CBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@DBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@EBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@FBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@GBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@HBUDGET /data/duplikat/TEMPO/
#rsync -avz root@192.168.110.32:/data1/apps/@KBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@MBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@NBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@PBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@QBUDGET /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@TBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@UBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@VBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@wBudget /data/duplikat/TEMPO/
rsync -avz root@192.168.110.32:/data1/apps/@TVBudget /data/duplikat/TEMPO/

#
rsync -avz root@192.168.110.34:/data1/apps/#pjk_sir/ /data/duplikat/TEMPO/PJK_SIR/
rsync -avz root@192.168.110.34:/data1/apps/@bapenas /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@billing /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@IKLAN_BARU /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@IKLANLOKAL /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@ikoran /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@JURNAL_IKLAN /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@markom /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@miklan /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@piu_tmp /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@SIRKULASICETAK /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/@timi /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/CFB /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/Honorer /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/Inventori /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/INVOICE /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/Kas_Bank /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/Kwi.Manual /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/kwitansi /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/Kwitansilangganan /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/NBMK09 /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/NBMK09_lama /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/ncf_2009 /data/duplikat/TEMPO/
#rsync -avz root@192.168.110.34:/data1/apps/ncf_2009_lama /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/NEWSIRKULASI /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/PRG21 /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/SeriPajak /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/SIRKULASI /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/SLIP /data/duplikat/TEMPO/
rsync -avz root@192.168.110.34:/data1/apps/SLIP_TPT /data/duplikat/TEMPO/

rsync -avz root@192.168.110.35:/data1/apps/MBM /data/duplikat/TEMPO/
rsync -avz root@192.168.110.35:/data1/apps/SISKO /data/duplikat/TEMPO/

# ====== PUSH TO GITHUB ==========
