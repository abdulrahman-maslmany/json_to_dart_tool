class CleanArchGenerator {
  final String featureName;
  final Map<String, String> fields;

  CleanArchGenerator({
    required this.featureName,
    required this.fields,
  });

  String get _featureLower => featureName.toLowerCase();

  // 1. Domain: Entity
  String generateEntity() {
    final fieldsDef =
        fields.entries.map((e) => '  final ${e.value} ${e.key};').join('\n');
    final constructorParams =
        fields.keys.map((k) => 'required this.$k,').join(' ');
    final props = fields.keys.join(', ');

    return '''
import 'package:equatable/equatable.dart';

class ${featureName}Entity extends Equatable {
$fieldsDef

  const ${featureName}Entity({$constructorParams});

  @override
  List<Object?> get props => [$props];
}
''';
  }

  // 2. Domain: Repository Contract
  String generateRepositoryContract() {
    return '''
import 'package:dartz/dartz.dart';
import '../entities/${_featureLower}_entity.dart';

abstract class ${featureName}Repository {
  Future<Either<dynamic, ${featureName}Entity>> get$featureName();
}
''';
  }

  // 3. Domain: UseCase
  String generateUseCase() {
    return '''
import 'package:dartz/dartz.dart';
import '../entities/${_featureLower}_entity.dart';
import '../repositories/${_featureLower}_repository.dart';

class Get${featureName}UseCase {
  final ${featureName}Repository repository;

  Get${featureName}UseCase(this.repository);

  Future<Either<dynamic, ${featureName}Entity>> call() async {
    return await repository.get$featureName();
  }
}
''';
  }

  // 4. Data: Remote DataSource
  String generateDataSource() {
    return '''
import 'package:dio/dio.dart';
import '../models/${_featureLower}_model.dart';

abstract class ${featureName}RemoteDataSource {
  Future<${featureName}Model> get$featureName();
}

class ${featureName}RemoteDataSourceImpl implements ${featureName}RemoteDataSource {
  final Dio dio;

  ${featureName}RemoteDataSourceImpl(this.dio);

  @override
  Future<${featureName}Model> get$featureName() async {
    final response = await dio.get('/$_featureLower');
    return ${featureName}Model.fromJson(response.data);
  }
}
''';
  }

  // 5. Data: Repository Implementation
  String generateRepositoryImpl() {
    return '''
import 'package:dartz/dartz.dart';
import '../../domain/entities/${_featureLower}_entity.dart';
import '../../domain/repositories/${_featureLower}_repository.dart';
import '../datasources/${_featureLower}_remote_datasource.dart';

class ${featureName}RepositoryImpl implements ${featureName}Repository {
  final ${featureName}RemoteDataSource remoteDataSource;

  ${featureName}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<dynamic, ${featureName}Entity>> get$featureName() async {
    try {
      final result = await remoteDataSource.get$featureName();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
''';
  }

  // 6. Presentation: Cubit & State
  String generateCubit() {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/${_featureLower}_entity.dart';
import '../../domain/usecases/get_${_featureLower}_usecase.dart';

// States
abstract class ${featureName}State {}
class ${featureName}Initial extends ${featureName}State {}
class ${featureName}Loading extends ${featureName}State {}
class ${featureName}Loaded extends ${featureName}State {
  final ${featureName}Entity $_featureLower;
  ${featureName}Loaded(this.$_featureLower);
}
class ${featureName}Error extends ${featureName}State {
  final String message;
  ${featureName}Error(this.message);
}

// Cubit
class ${featureName}Cubit extends Cubit<${featureName}State> {
  final Get${featureName}UseCase get${featureName}UseCase;

  ${featureName}Cubit(this.get${featureName}UseCase) : super(${featureName}Initial());

  Future<void> fetch$featureName() async {
    emit(${featureName}Loading());
    final result = await get${featureName}UseCase();
    result.fold(
      (failure) => emit(${featureName}Error(failure.toString())),
      (data) => emit(${featureName}Loaded(data)),
    );
  }
}
''';
  }
}
