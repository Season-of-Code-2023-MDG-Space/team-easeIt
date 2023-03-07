import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:external_path/external_path.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pdf_merger/pdf_merger.dart';

import '../../../domain/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  List<PlatformFile> files = [];
  List<String> filesPath = [];
  String singleFile = '';
  Future<bool> checkPermission() async {
    Permission storagePermission = Permission.storage;
    if (await storagePermission.isGranted) {
      return true;
    } else if (await storagePermission.isPermanentlyDenied) {
      return false;
    } else {
      await storagePermission.request();
      storagePermission = Permission.storage;
      return (await storagePermission.isPermanentlyDenied ||
              await storagePermission.isDenied)
          ? false
          : true;
    }
  }

  Future<String> getFilePath(String fileStartName) async {
    String path = '';
    if (GetPlatform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      path = appDocDir.path;
    } else if (GetPlatform.isAndroid) {
      path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
    }
    return "$path/$fileStartName.pdf";
  }

  HomeBloc({required this.userRepository, required this.authRepository})
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      on<GetUserDataEvent>((event, emit) async {
        emit(const Loading());
        try {
          final result = await userRepository.getUserDetails();
          emit(Success(result));
        } catch (e) {
          emit(Error(e.toString()));
        }
      });
      on<Logout>((event, emit) async {
        emit(const Loading());
        try {
          await authRepository.signOutFromGoogle();
          emit(const LogoutSuccess());
        } on firebase_auth.FirebaseAuthException catch (e) {
          emit(Error(e.toString()));
        }
      });
      on<PDFPickEvent>((event, emit) async {
        emit(const Loading());
        bool isGranted = await checkPermission();
        if (isGranted) {
          try {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(allowMultiple: true);
            if (result != null) {
              files.addAll(result.files);
              for (int i = 0; i < result.files.length; i++) {
                filesPath.add(result.files[i].path!);
              }
            } else {
              // User canceled the picker
            }
            String dirPath = await getFilePath('PDF-3');
            try {
              MergeMultiplePDFResponse response =
                  await PdfMerger.mergeMultiplePDF(
                      paths: filesPath, outputDirPath: dirPath);
              final File file = File(dirPath);
              PdfDocument document =
                  PdfDocument(inputBytes: file.readAsBytesSync());
              await file.delete();
              List<MatchedItem> findResult =
                  PdfTextExtractor(document).findText(['Fullering']);
              if (findResult.isEmpty) {
                document.dispose();
                Get.snackbar('No Results are Found',
                    'The Selected PDF(s) does not contains the required results.');
              } else {
                for (int i = 0; i < findResult.length; i++) {
                  MatchedItem item = findResult[i];
                  PdfPage page = document.pages[item.pageIndex];
                  page.graphics.save();
                  page.graphics.setTransparency(0.5);
                  page.graphics.drawRectangle(
                      bounds: item.bounds, brush: PdfBrushes.yellow);
                  page.graphics.restore();
                }
                final List<int> bytes = await document.save();
                document.dispose();
                final Directory directory =
                    await getApplicationDocumentsDirectory();
                final String path = directory.path;
                final File file = File('$path/output.pdf');
                await file.writeAsBytes(bytes);
                File outputFile = File('$path/output.pdf');
                emit(ShowResultPDF(
                    pdfFile: outputFile, resultsData: findResult));
              }
            } catch (err) {
              emit(Error(err.toString()));
            }
          } catch (e) {
            emit(Error(e.toString()));
          }
        }
      });
    });
  }
}
