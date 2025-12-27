// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fiber_foundation_locale/src/services/device/network_service.dart'
    as _i210;
import 'package:fiber_foundation_locale/src/services/locale/currency_service.dart'
    as _i332;
import 'package:fiber_foundation_locale/src/services/settings/preferences_service.dart'
    as _i218;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await gh.singletonAsync<_i218.PreferencesService>(
      () => _i218.PreferencesService.create(),
      preResolve: true,
    );
    gh.singleton<_i210.NetworkService>(
      () => _i210.NetworkServiceImpl()..init(),
    );
    gh.singleton<_i332.CurrencyService>(
      () => _i332.CurrencyServiceImpl(
        gh<_i218.PreferencesService>(),
        gh<_i210.NetworkService>(),
      )..init(),
    );
    return this;
  }
}
