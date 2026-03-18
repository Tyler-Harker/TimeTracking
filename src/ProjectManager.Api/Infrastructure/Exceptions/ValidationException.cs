using FluentValidation.Results;

namespace ProjectManager.Api.Infrastructure.Exceptions;

public class ValidationException(IEnumerable<ValidationFailure> failures) : Exception("One or more validation failures occurred.")
{
    public IDictionary<string, string[]> Errors { get; } = failures
        .GroupBy(f => f.PropertyName, f => f.ErrorMessage)
        .ToDictionary(g => g.Key, g => g.ToArray());
}
