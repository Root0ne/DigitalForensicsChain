# Adli Bilişim Süreçlerinde Blok Zinciri Teknolojisinin Uygulanması (DEMO)

Adli bilişim sürecindeki delillerin tüm aşamalar boyunca güvenli bir şekilde yönetilmesi için blok zinciri tabanlı bir platform.

## İçindekiler

- [Giriş](#giriş)
- [Proje Özeti](#proje-özeti)
- [Özellikler](#özellikler)
- [Kontrat](#kontrat)
  - [Gereksinimler](#gereksinimler)
  - [Kurulum](#kurulum)
  - [Dağıtım](#dağıtım)
- [Kullanım](#kullanım)

## Giriş

Bu proje, adli bilişim sürecindeki delillerin güvenliğini ve bütünlüğünü artırmak amacıyla blok zinciri tabanlı bir platform uygular. Akıllı kontratlar kullanarak, sistem delil karartmayı önlemeyi, şeffaflığı sağlamayı ve dijital deliller için doğrulanabilir bir muhafaza zinciri sunmayı hedefler.

## Proje Özeti

`DigitalForensicsChain.sol` akıllı kontratı Solidity dilinde yazılmış olup, farklı katılımcılar için rollerin yönetilmesi amacıyla rol tabanlı erişim kontrolü kullanır. Kontrat, delil ve rapor verilerini dört ana aşamada kaydeder:

1. **Tanımlama Aşaması**: Olay yerinden delillerin toplanması ve kaydedilmesi.
2. **İnceleme Aşaması**: Delillerin ön analizi ve imajlarının alınması.
3. **Analiz Aşaması**: Adli bilişim uzmanları tarafından yapılan detaylı analiz.
4. **Raporlama Aşaması**: Bulguların raporlanması ve yetkili makamlara iletilmesi.

## Özellikler

- **Rol Tabanlı Erişim Kontrolü**: Farklı katılımcılara belirli fonksiyonlara erişim izni veren roller (`ROLE_TANIMLAMA`, `ROLE_INCELEME`, `ROLE_ANALIZ`, `ROLE_RAPORLAMA`) atanır.
- **Değiştirilemez Kayıtlar**: Tüm girişler blok zincirine kaydedilir, bu da veri bütünlüğünü ve şeffaflığı sağlar.
- **Olay Kaydı**: Önemli işlemler, izlemeyi ve takibi kolaylaştıran olayları tetikler.
- **Yönetici Kontrolleri**: Bir yönetici, roller atayabilir veya iptal edebilir ve dava numarasını belirleyebilir.

## Kontrat

Bu kontrat, yerel çalışma ortamında derlenip çalıştırılacağı gibi [Remix IDE](https://remix.ethereum.org/) kullanılarak da online olarak derlenebilir.

Yerelde çalıştırmak için aşağıdaki adımları izleyebilirsiniz.

### Gereksinimler

- **Node.js ve npm**: [Node.js resmi web sitesi](https://nodejs.org/) üzerinden yükleyin.
- **Truffle Framework**: Akıllı kontratların derlenmesi ve dağıtımı için.

  ```bash
  npm install -g truffle
  ```

- **Ganache**: Test amaçlı kişisel Ethereum blok zinciri.

  ```bash
  npm install -g ganache-cli
  ```

- **MetaMask**: Blok zinciri ile etkileşim için tarayıcı uzantısı.

### Kurulum

1. **Depoyu Klonlayın**

   ```bash
   git clone https://github.com/Roor0ne/DigitalForensicsChain.git
   cd DigitalForensicsChain
   ```

2. **Bağımlılıkları Yükleyin**

   ```bash
   npm install
   ```

### Dağıtım

1. **Ganache'ı Başlatın**

   ```bash
   ganache-cli
   ```

2. **Akıllı Kontratı Derleyin**

   ```bash
   truffle compile
   ```

3. **Akıllı Kontratı Dağıtın**

   ```bash
   truffle migrate
   ```

## Kullanım

1. **Rollerin Atanışı**

   - Yönetici, `assignRole` fonksiyonunu kullanarak farklı adreslere roller atar.
   - Roller, farklı aşamalara karşılık gelir:
     - `ROLE_TANIMLAMA`: Tanımlama Aşaması
     - `ROLE_INCELEME`: İnceleme Aşaması
     - `ROLE_ANALIZ`: Analiz Aşaması
     - `ROLE_RAPORLAMA`: Raporlama Aşaması

2. **Dava Numarasının Belirlenmesi**

   - Yönetici, `setCaseNumber` fonksiyonunu kullanarak dava numarasını belirler.
   - Bu işlem, kontrat başına sadece bir kez yapılabilir.

3. **Delil Eklenmesi**

   - Katılımcılar, kendi aşamalarında delil eklemek için aşağıdaki fonksiyonları kullanır:
     - `addEvidenceIdentificationPhase`
     - `addEvidenceExaminationPhase`
     - `addEvidenceAnalysisPhase`

4. **Rapor Eklenmesi**

   - Raporlama Aşamasında, uzman `addReport` fonksiyonunu kullanarak rapor hash değerini ekler.

5. **Verilere Erişim**

   - Yönetici, tüm aşamalardaki verileri aşağıdaki getter fonksiyonları ile alabilir:
     - `getIdentificationPhaseEvidence`
     - `getExaminationPhaseEvidence`
     - `getAnalysisPhaseEvidence`
     - `getReports`

