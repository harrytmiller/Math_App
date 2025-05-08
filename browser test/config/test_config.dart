class BrowserTestConfig {

  static const String chromeDriverPath = 'browser test/drivers/chromedriver.exe';
  static const String edgeDriverPath = 'browser test/drivers/msedgedriver.exe';
  static const String firefoxDriverPath = 'browser test/drivers/geckodriver.exe';
  
  static const int chromePort = 4444;
  static const int edgePort = 4445;
  static const int firefoxPort = 4446;
  
  static const int serverPort = 8080;
  static const String serverHost = 'localhost';
  static const int testTimeout = 90;
}