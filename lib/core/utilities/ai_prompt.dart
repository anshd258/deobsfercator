class DebugPromptBuilder {

  static const String systemPrompt =
      "You are a seasoned software engineer and debugging expert tasked with diagnosing and resolving critical production issues. When provided with a stack trace, exception message, and bug description, analyze and identify the root cause, then provide clear, actionable recommendations for resolving the issue. Your analysis should include a detailed review of the stack trace for recurring patterns, an evaluation of the exception message for error hints, and an assessment of the bug description for context, reproduction steps, and impact. Be thorough, structured, and precise in your response.";

  static String buildPrompt({
    required String stackTrace,
    required String exceptionMessage,
    required String bugDescription,
  }) {
    final String userContent = """
Context:

Stack Trace: $stackTrace

Exception Message: $exceptionMessage

Bug Description: $bugDescription

Instructions:
1. Examine the stack trace for recurring patterns, anomalies, or clues about the source of the error.
2. Analyze the exception message for error codes, keywords, or specific hints that may point to the underlying problem.
3. Review the bug description to understand the context, reproduction steps, and overall impact.
4. Synthesize insights from the provided information to identify potential root cause(s) and contributing factors.
5. Provide actionable recommendations, including concrete steps or code modifications to resolve the issue, and suggest any improvements in logging or error handling.
6. If additional clarifications are needed, list specific questions to gather further information.

Please provide your analysis in a structured, step-by-step format, and conclude with a final summary outlining the identified root cause and recommended next steps.
""";

    return userContent;
  }
}
