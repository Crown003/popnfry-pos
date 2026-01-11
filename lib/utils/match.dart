bool matchesSearch(String text, String query) {
  text = text.toLowerCase();
  query = query.toLowerCase();

  int textIndex = 0;
  int queryIndex = 0;

  while (textIndex < text.length && queryIndex < query.length) {
    if (text[textIndex] == query[queryIndex]) {
      queryIndex++;
    }
    textIndex++;
  }

  return queryIndex == query.length;
}