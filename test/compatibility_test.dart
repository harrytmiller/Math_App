import 'package:flutter_test/flutter_test.dart';
import 'package:webdriver/async_io.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group('Browser Compatibility Tests', () {
    final routes = [
      '/',
      '/login',
      '/register',
      '/faq',
      '/about',
      '/question',
      '/profile',
    ];
    


    test('Chrome', () async {
      final driverPath = 'browser test/drivers/chromedriver.exe';
      final process = await Process.start(
        driverPath,
        ['--port=4444', '--silent'],
      );
      
      await Future.delayed(Duration(seconds: 2));
      
      WebDriver? driver;
      try {
        driver = await createDriver(
          uri: Uri.parse('http://localhost:4444/'),
          desired: {
            'browserName': 'chrome',
            'goog:chromeOptions': {
              'args': ['--headless'],
            },
          },
        );
        
        bool allRoutesWorked = true;
        for (final route in routes) {
          try {
            await driver.get('http://localhost:8080$route');
            await Future.delayed(Duration(seconds: 2));
          } catch (e) {
            allRoutesWorked = false;
          }
        }
        
        expect(allRoutesWorked, isTrue);
      } finally {
        if (driver != null) {
          await driver.quit();
        }
        
        process.kill();
      }
    });
    


    
    test('Edge', () async {
      final driverPath = 'browser test/drivers/msedgedriver.exe';
      final process = await Process.start(
        driverPath,
        ['--port=4445', '--silent'],
      );
      
      await Future.delayed(Duration(seconds: 2));
      
      WebDriver? driver;
      try {
        driver = await createDriver(
          uri: Uri.parse('http://localhost:4445/'),
          desired: {
            'browserName': 'MicrosoftEdge',
            'ms:edgeOptions': {
              'args': ['--headless'],
            },
          },
        );
        
        bool allRoutesWorked = true;
        for (final route in routes) {
          try {
            await driver.get('http://localhost:8080$route');
            await Future.delayed(Duration(seconds: 2));
          } catch (e) {
            allRoutesWorked = false;
          }
        }
        
        expect(allRoutesWorked, isTrue);
      } finally {
        if (driver != null) {
          await driver.quit();
        }
        
        process.kill();
      }
    });





    test('Firefox', () async {
      try {
        await Process.run('taskkill', ['/F', '/IM', 'geckodriver.exe']);
        await Process.run('taskkill', ['/F', '/IM', 'firefox.exe']);
      } catch (e) {
      }
      
      final driverPath = 'browser test/drivers/geckodriver.exe';
      final process = await Process.start(
        driverPath,
        ['--port=4446', '--allow-system-access'],
      );
      
      process.stdout.transform(utf8.decoder).listen((data) {});
      process.stderr.transform(utf8.decoder).listen((data) {});
      
      await Future.delayed(Duration(seconds: 5));
      
      WebDriver? driver;
      try {
        driver = await createDriver(
          uri: Uri.parse('http://localhost:4446/'),
          desired: {
            'browserName': 'firefox',
            'moz:firefoxOptions': {
              'args': ['--headless'],
              'binary': 'C:\\Program Files\\Mozilla Firefox\\firefox.exe',
            },
          },
        );
        
        bool allRoutesWorked = true;
        for (final route in routes) {
          try {
            await driver.get('http://localhost:8080$route');
            await Future.delayed(Duration(seconds: 2));
          } catch (e) {
            allRoutesWorked = false;
          }
        }
        
        expect(allRoutesWorked, isTrue);
      } finally {
        if (driver != null) {
          try {
            await driver.quit();
          } catch (e) {
          }
        }
        
        process.kill();
        
        try {
          await Process.run('taskkill', ['/F', '/IM', 'geckodriver.exe']);
          await Process.run('taskkill', ['/F', '/IM', 'firefox.exe']);
        } catch (e) {
        }
      }
    });
  });
}