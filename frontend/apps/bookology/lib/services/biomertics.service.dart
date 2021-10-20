/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsService {
  final BuildContext context;
  final LocalAuthentication biometricAuth = LocalAuthentication();

  BiometricsService(this.context);

  Future<bool> isBiometricsAvailable() async {
    if (await biometricAuth.isDeviceSupported()) {
      return true;
    }

    return false;
  }

  Future<bool> canCheckBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await biometricAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
      rethrow;
    }
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await biometricAuth.getAvailableBiometrics();
    } on PlatformException {
      availableBiometrics = <BiometricType>[];
      rethrow;
    }

    return availableBiometrics;
  }

  Future<bool> authenticateWithBiometrics({
    required String bioAuthReason,
    required bool useOnlyBiometrics,
    required VoidCallback onBioAuthStarted,
    required Function(bool) onBioAuthCompleted,
    required Function(PlatformException) onBioAuthError,
  }) async {
    bool authenticated = false;
    try {
      onBioAuthStarted();
      authenticated = await biometricAuth.authenticate(
        localizedReason: bioAuthReason,
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: useOnlyBiometrics,
      );
      onBioAuthCompleted(authenticated);
      return authenticated;
    } on PlatformException catch (error) {
      onBioAuthError(error);
      return false;
    }
  }

  void cancelAuthentication() async {
    await biometricAuth.stopAuthentication();
  }
}
