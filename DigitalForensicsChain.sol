// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DigitalForensicsChain is AccessControl {
    // Roller tanımlandı. Her bir aşama için ayrı bir rol oluşturuldu.
    bytes32 public constant ROLE_TANIMLAMA = keccak256("ROLE_TANIMLAMA");
    bytes32 public constant ROLE_INCELEME = keccak256("ROLE_INCELEME");
    bytes32 public constant ROLE_ANALIZ = keccak256("ROLE_ANALIZ");
    bytes32 public constant ROLE_RAPORLAMA = keccak256("ROLE_RAPORLAMA");

    // Dava numarası ve dava numarasının belirlenip belirlenmediğini tutan değişkenler.
    string public caseNumber;
    bool private caseNumberSet = false;

    // Kontratın kurucusu belirlenir ve DEFAULT_ADMIN_ROLE atanır.
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Olaylar (Events) tanımlandı. Bu olaylar, önemli işlemlerde tetiklenecek.
    event CaseNumberSet(string caseNumber);
    event EvidenceAdded(
        string phase,
        string caseNumber,
        string evidenceNumber,
        string description,
        string officerName,
        address officerAddress
    );
    event ReportAdded(
        string caseNumber,
        string reportHash,
        string expertName,
        address expertAddress
    );

    // Delil ve Rapor için yapılar tanımlandı
    struct Evidence {
        string caseNumber;          // Dava numarası
        string evidenceNumber;      // Delil numarası
        string description;         // Delil açıklaması
        string hashValue;           // Delil hash değeri (opsiyonel)
        string toolsUsed;           // Kullanılan araçlar (opsiyonel)
        string officerName;         // Görevli veya bilirkişinin adı soyadı
        address officerAddress;     // Görevlinin adresi
    }

    struct Report {
        string caseNumber;          // Dava numarası
        string reportHash;          // Raporun hash değeri
        string expertName;          // Bilirkişinin adı soyadı
        address expertAddress;      // Bilirkişinin adresi
    }

    // Her aşama için deliller ve raporlar depolamak üzere diziler tanımlandı
    Evidence[] private identificationPhase;
    Evidence[] private examinationPhase;
    Evidence[] private analysisPhase;
    Report[] private reportingPhase;

    // Dava numarasını belirleyen fonksiyon. Sadece admin tarafından ve bir kez çağrılabilir
    function setCaseNumber(string memory _caseNumber) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!caseNumberSet, "Case number has already been set.");
        caseNumber = _caseNumber;
        caseNumberSet = true;
        emit CaseNumberSet(_caseNumber);
    }

    /*Dava numarasını sadece kontratı dağıtan kişi (admin) atayabilir
      Dava numarası bir kez girildikten sonra tekrar değiştirilemez ve zincire yazılan her veri dava numarası ile beraber otomatik yazılır.*/

    // Tanımlama aşamasında delil ekleyen fonksiyon
    function addEvidenceIdentificationPhase(
        string memory _evidenceNumber,
        string memory _description,
        string memory _officerName
    ) public onlyRole(ROLE_TANIMLAMA) {
        Evidence memory newEvidence = Evidence(
            caseNumber,
            _evidenceNumber,
            _description,
            "",
            "",
            _officerName,
            msg.sender
        );
        identificationPhase.push(newEvidence);
        emit EvidenceAdded(
            "Identification",
            caseNumber,
            _evidenceNumber,
            _description,
            _officerName,
            msg.sender
        );
    }

    /*Tanımlama aşamasında delil eklemek için kullanılır.
      Bu fonksiyonu sadece ROLE_TANIMLAMA rolüne sahip olanlar çağırabilir.
      Delilin hash değeri ve kullanılan araçlar bu aşamada boş bırakılır.*/

    // İnceleme aşamasında delil ekleyen fonksiyon
    function addEvidenceExaminationPhase(
        string memory _evidenceNumber,
        string memory _description,
        string memory _hashValue,
        string memory _toolsUsed,
        string memory _officerName
    ) public onlyRole(ROLE_INCELEME) {
        Evidence memory newEvidence = Evidence(
            caseNumber,
            _evidenceNumber,
            _description,
            _hashValue,
            _toolsUsed,
            _officerName,
            msg.sender
        );
        examinationPhase.push(newEvidence);
        emit EvidenceAdded(
            "Examination",
            caseNumber,
            _evidenceNumber,
            _description,
            _officerName,
            msg.sender
        );
    }

    /*İnceleme aşamasında delil eklemek için kullanılır
      Bu fonksiyonu sadece ROLE_INCELEME rolüne sahip olanlar çağırabilir
      Delilin hash değeri ve kullanılan araçlar bu aşamada girilir*/

    // Analiz aşamasında delil ekleyen fonksiyon
    function addEvidenceAnalysisPhase(
        string memory _evidenceNumber,
        string memory _description,
        string memory _hashValue,
        string memory _toolsUsed,
        string memory _expertName
    ) public onlyRole(ROLE_ANALIZ) {
        Evidence memory newEvidence = Evidence(
            caseNumber,
            _evidenceNumber,
            _description,
            _hashValue,
            _toolsUsed,
            _expertName,
            msg.sender
        );
        analysisPhase.push(newEvidence);
        emit EvidenceAdded(
            "Analysis",
            caseNumber,
            _evidenceNumber,
            _description,
            _expertName,
            msg.sender
        );
    }

    /*Analiz aşamasında delil eklemek için kullanılır
      Bu fonksiyonu sadece ROLE_ANALIZ rolüne sahip olanlar çağırabilir
      Bilirkişi tarafından alınan veya aktarılan delillerin bilgileri girilir*/

    // Raporlama aşamasında rapor ekleyen fonksiyon
    function addReport(
        string memory _reportHash,
        string memory _expertName
    ) public onlyRole(ROLE_RAPORLAMA) {
        Report memory newReport = Report(
            caseNumber,
            _reportHash,
            _expertName,
            msg.sender
        );
        reportingPhase.push(newReport);
        emit ReportAdded(caseNumber, _reportHash, _expertName, msg.sender);
    }

    /*Raporlama aşamasında rapor eklemek için kullanılır
      Bu fonksiyonu sadece ROLE_RAPORLAMA rolüne sahip olanlar çağırabilir
      Raporun hash değeri ve bilirkişinin bilgileri girilir*/

    // Tanımlama aşamasındaki tüm delilleri getiren fonksiyon. Sadece admin çağırabilir
    function getIdentificationPhaseEvidence() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (Evidence[] memory) {
        return identificationPhase;
    }

    // İnceleme aşamasındaki tüm delilleri getiren fonksiyon. Sadece admin çağırabilir
    function getExaminationPhaseEvidence() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (Evidence[] memory) {
        return examinationPhase;
    }

    // Analiz aşamasındaki tüm delilleri getiren fonksiyon. Sadece admin çağırabilir
    function getAnalysisPhaseEvidence() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (Evidence[] memory) {
        return analysisPhase;
    }

    // Raporları getiren fonksiyon. Sadece admin çağırabilir
    function getReports() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (Report[] memory) {
        return reportingPhase;
    }

    /*Yukarıdaki get fonksiyonları, ilgili aşamalardaki verileri döndürür
      Bu fonksiyonları sadece kontratın admini çağırabilir, böylece verilerin gizliliği korunur.*/

    // Roller atamak için kullanılan fonksiyon. Sadece admin çağırabilir.
    function assignRole(bytes32 role, address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(role, account);
    }

    // Roller geri almak için kullanılan fonksiyon. Sadece admin çağırabilir
    function revokeRoleCustom(bytes32 role, address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(role, account);
    }

    /*Yukarıdaki fonksiyonlar ile admin, belirli adreslere roller atayabilir veya rollerini geri alabilir
      Bu sayede yetkilendirme dinamik olarak yönetilebilir.*/
}
