export class ApiException extends Error {
  readonly statusCode?: number;

  constructor(message: string, statusCode?: number) {
    super(message);
    this.name = "ApiException";
    this.statusCode = statusCode;
  }

  static fromResponse(statusCode: number, data: unknown): ApiException {
    if (data && typeof data === "object" && data !== null) {
      const obj = data as Record<string, unknown>;

      if (statusCode === 422 && obj.errors) {
        const fieldErrors: Record<string, string[]> = {};
        const errors = obj.errors as Record<string, unknown>;
        for (const [key, value] of Object.entries(errors)) {
          fieldErrors[key] = (value as unknown[]).map(String);
        }
        return new ValidationApiException(
          (obj.error as string) ?? "Validation failed",
          statusCode,
          fieldErrors
        );
      }

      return new ApiException(
        (obj.error as string) ?? "An unexpected error occurred",
        statusCode
      );
    }

    return new ApiException("An unexpected error occurred", statusCode);
  }
}

export class ValidationApiException extends ApiException {
  readonly fieldErrors: Record<string, string[]>;

  constructor(
    message: string,
    statusCode: number | undefined,
    fieldErrors: Record<string, string[]>
  ) {
    super(message, statusCode);
    this.name = "ValidationApiException";
    this.fieldErrors = fieldErrors;
  }

  firstErrorFor(field: string): string | undefined {
    const errors =
      this.fieldErrors[field] ??
      this.fieldErrors[field.charAt(0).toUpperCase() + field.slice(1)];
    return errors?.[0];
  }

  get allErrors(): string {
    return Object.values(this.fieldErrors)
      .flat()
      .join("\n");
  }
}

export class UnauthorizedException extends ApiException {
  constructor(message = "Unauthorized") {
    super(message, 401);
    this.name = "UnauthorizedException";
  }
}

export class NetworkException extends ApiException {
  constructor(message = "Network error. Please check your connection.") {
    super(message);
    this.name = "NetworkException";
  }
}
