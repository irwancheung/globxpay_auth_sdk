
import 'package:globxpay_auth_sdk/api/network.dart';

import '../../constants/app_assets.dart';

List<RegistrationDocumentTypeMode> jordanianType = [
  RegistrationDocumentTypeMode(
    id: 1,
    documentTypeDB: 17,
    keyOfName: 'jordanianID',
    productionJourneyId:Network.jordanianFlowProductionKey,
    stagingJourneyId: Network.jordanianFlowStagingKey,
    images: const [
      AppAssets.idFrontSide,
      AppAssets.idBackSide,
    ],
    code: '601',
  ),
  RegistrationDocumentTypeMode(
    id: 2,
    documentTypeDB: 5,
    keyOfName: 'militaryCard',
    productionJourneyId: Network.militaryCardFlowProductionKey,
    stagingJourneyId: Network.militaryCardFlowStagingKey,
    images: const [
      AppAssets.idFrontMilitary,
      AppAssets.idBackMilitary,
    ],
    code: '608',
  ),
  // const RegistrationDocumentTypeMode(
  //   id: 8,
  //   documentTypeDB: 5701,
  //   keyOfName: 'ATFX-Livness-Check',
  //   productionJourneyId: '8fb6c1b0-54ea-40b5-85b7-e8fcb973baef',
  //   stagingJourneyId: '8fb6c1b0-54ea-40b5-85b7-e8fcb973baef',
  //   images: [
  //     AppAssets.scanSelfieCircle,
  //   ],
  //   code: '022',
  // ),
  // const RegistrationDocumentTypeMode(
  //   id: 8,
  //   documentTypeDB: 5693,
  //   keyOfName: 'CertificateOfAppointment',
  //   productionJourneyId: '4fca4419-b5f8-404a-b032-7ef600785681',
  //   stagingJourneyId: '4fca4419-b5f8-404a-b032-7ef600785681',
  //   images: [
  //     AppAssets.idFrontCertificateOfAppointment,
  //     AppAssets.idBackCertificateOfAppointment,
  //   ],
  //   code: '620',
  // ),
];

List<RegistrationDocumentTypeMode> nonJordanianType = [
  RegistrationDocumentTypeMode(
    id: 3,
    documentTypeDB: 19,
    keyOfName: 'passport',
    productionJourneyId: Network.passportFlowProductionKey,
    stagingJourneyId: Network.passportFlowStagingKey,
    images: const [
      AppAssets.passport,
    ],
    code: '603',
  ),
  RegistrationDocumentTypeMode(
    id: 4,
    documentTypeDB: 5694,
    keyOfName: 'gaza',
    productionJourneyId: Network.sonsOfGazaFlowProductionKey,
    stagingJourneyId: Network.sonsOfGazaFlowStagingKey,
    images: const [
      AppAssets.idFrontGaza,
      AppAssets.idBackGaza,
    ],
    code: '622',
  ),
  RegistrationDocumentTypeMode(
    id: 5,
    documentTypeDB: 5696,
    keyOfName: 'residentID',
    productionJourneyId: Network.residentCardFlowProductionKey,
    stagingJourneyId: Network.residentCardFlowStagingKey,
    images: const [
      AppAssets.idFrontResidency,
      AppAssets.idBackResidency,
    ],
    code: '627',
  ),
  RegistrationDocumentTypeMode(
    id: 6,
    documentTypeDB: 82,
    keyOfName: 'sonOfJordanianWomen',
    productionJourneyId: Network.sonsOfJordanianWomenFlowProductionKey,
    stagingJourneyId: Network.sonsOfJordanianWomenFlowStagingKey,
    images: const [
      AppAssets.idFrontChildrenOfJordanianWomen,
      AppAssets.idBackChildrenOfJordanianWomen,
    ],
    code: '607',
  ),
  RegistrationDocumentTypeMode(
    id: 7,
    documentTypeDB: 5695,
    keyOfName: 'syrianRefugeeCard',
    productionJourneyId: Network.syrianRefugeeCardFlowProductionKey,
    stagingJourneyId: Network.syrianRefugeeCardFlowStagingKey,
    images: const [
      AppAssets.idFrontSyrian,
      AppAssets.idBackSyrian,
    ],
    code: '623',
  ),
  RegistrationDocumentTypeMode(
    id: 8,
    documentTypeDB: 5742,
    keyOfName: 'travelDocument',
    productionJourneyId: Network.travelDocumentFlowProductionKey,
    stagingJourneyId: Network.travelDocumentFlowStagingKey,
    images: const [
      AppAssets.passport,
    ],
    code: '630',
  ),
];
// List<RegistrationDocumentTypeMode> atfxLivness = [
//   const RegistrationDocumentTypeMode(
//     id: 8,
//     documentTypeDB: 5701,
//     keyOfName: 'ATFX-Liveness-Check',
//     productionJourneyId: '8fb6c1b0-54ea-40b5-85b7-e8fcb973baef',
//     stagingJourneyId: '8fb6c1b0-54ea-40b5-85b7-e8fcb973baef',
//     images: [
//       AppAssets.scanSelfieCircle,
//     ],
//     code: '022',
//   ),
// ];

final class RegistrationDocumentTypeMode {
  final int id;
  final String keyOfName;
  final int documentTypeDB;
  final String code;
  final String stagingJourneyId;
  final String productionJourneyId;
  final List<String> images;

  const RegistrationDocumentTypeMode({
    required this.id,
    required this.keyOfName,
    required this.documentTypeDB,
    required this.stagingJourneyId,
    required this.productionJourneyId,
    required this.images,
    required this.code,
  });
}
