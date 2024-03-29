///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 11/26/20 7:45 PM
///
import 'dart:io';

import 'package:args/args.dart';

const String _constKey = 'FromJson(';
const String _prefixKey = r'_$';

late final File generateFile;
late final File targetFile;

Future<void> main(List<String> arguments) async {
  final ArgParser parser = ArgParser()
    ..addOption(
      'model',
      abbr: 'm',
      defaultsTo: 'lib/models/data_model.dart',
      help: 'Your model file path.',
    )
    ..addOption(
      'generated',
      abbr: 'g',
      defaultsTo: 'lib/models/data_model.g.dart',
      help: 'Your generated file path.',
    )
    ..addOption(
      'data',
      abbr: 'd',
      defaultsTo: 'lib/models/data_model.d.dart',
      help: 'Your data factories file path.',
    )
    ..addOption(
      'name',
      abbr: 'n',
      defaultsTo: 'dataModelFactories',
      help: 'Your factories name.',
    );
  final ArgResults results = parser.parse(arguments);

  final String mPath = results['model'] as String;
  final String gPath = results['generated'] as String;
  final String tPath = results['data'] as String;
  final String factoriesName = results['name'] as String;
  generateFile = File(gPath);
  targetFile = File(tPath);
  if (!targetFile.existsSync()) {
    await targetFile.create(recursive: true);
  }
  generateFile.readAsLines().then((List<String> lines) {
    makeModel(mPath, factoriesName, lines);
  });
}

void makeModel(
  String generateFilePath,
  String factoriesName,
  List<String> lines,
) {
  String modelContent = 'part of \'${generateFilePath.split('/').last}\';\n\n';
  modelContent += 'final Map<Type, DataFactory> $factoriesName = '
      '<Type, DataFactory>{\n';
  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    if (line.contains(_constKey) && line.contains(_prefixKey)) {
      final String className = line.split(' ')[0];
      modelContent += '  $className: (Map<String, dynamic> json) => '
          '$className.fromJson(json),\n';
    }
  }
  modelContent += '};\n';
  targetFile.writeAsString(modelContent);
}
