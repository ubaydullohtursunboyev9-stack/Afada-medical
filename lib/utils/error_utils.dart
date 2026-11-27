String getFriendlyErrorMessage(String? rawError, [String? fallback]) {
  if (rawError == null || rawError.trim().isEmpty) {
    return fallback ?? "Internet aloqasi yo'q";
  }

  final lower = rawError.toLowerCase();

  if (lower.contains("socketexception") ||
      lower.contains("clientexception") ||
      lower.contains("failed host lookup") ||
      lower.contains("networkimage") ||
      lower.contains("handshakeexception") ||
      lower.contains("timeoutexception") ||
      lower.contains("httpexception") ||
      lower.contains("no internet") ||
      lower.contains("connection") ||
      lower.contains("nodename") ||
      lower.contains("servname") ||
      lower.contains("errno") ||
      lower.contains("connect")) {
    return "Internet aloqasi yo'q";
  }

  if (lower.contains("401") || lower.contains("unauthorized") || lower.contains("unauthenticated")) {
    return "Tizimga qayta kiring";
  }

  if (lower.contains("500") || lower.contains("502") || lower.contains("503") || lower.contains("server")) {
    return "Server bilan aloqa o'rnatib bo'lmadi";
  }

  if (lower.contains("exception") || lower.contains("error") || lower.contains("http") || lower.contains("uri=")) {
    return "Internet aloqasi yo'q";
  }

  return rawError;
}
