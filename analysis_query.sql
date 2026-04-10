-- MEMBUAT TABEL ANALISIS AKHIR
CREATE OR REPLACE TABLE `rakamin-kf-analytics-492803.kimia_farma.analysis_table` AS
SELECT -- MEMILIH DATA YANG AKAN DIGUNAKAN
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,

  -- MENENTUKAN PERSENTASE GROSS LABA BERDASARKAN RANGE HARGA PRODUK
  CASE 
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- MENGHITUNG NETT SALES (RUMUS: HARGA - DISKON)
  t.price * (1 - t.discount_percentagea) AS nett_sales,

  -- MENGHITUNG NETT PROFIT (RUMUS: nett_sales * persentase_gross_laba)
  (t.price * (1 - t.discount_percentage)) *
  (CASE 
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END) AS nett_profit,

  -- Rating dari transaksi
  t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-492803.kimia_farma.kf_final_transaction` t -- SUMBER DATA UTAMA (TABEL TRANSAKSI)
JOIN `rakamin-kf-analytics-492803.kimia_farma.kf_product` p -- MENGGABUNGKAN DENGAN DATA PRODUK
  ON t.product_id = p.product_id
JOIN `rakamin-kf-analytics-492803.kimia_farma.kf_kantor_cabang` c -- MENGGABUNGKAN DENGAN DATA CABANG
  ON t.branch_id = c.branch_id;
