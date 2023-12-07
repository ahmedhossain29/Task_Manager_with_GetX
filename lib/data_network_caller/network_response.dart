//data class

class NetworkResponse {
  final int? statusCode;
  final bool isSuccess;
  final dynamic jsonResponse;
  final String errorMessage;
  //final String status;

  NetworkResponse({
    this.statusCode = -1,
    required this.isSuccess,
    this.jsonResponse,
    this.errorMessage = 'Something went wrong',
    //this.status = '',
  });
}
