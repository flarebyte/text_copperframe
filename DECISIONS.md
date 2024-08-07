# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

-   a functional requirement (features).
-   a non-functional requirement (technologies, methodologies, libraries).

The purpose is to understand the reasons behind the current architecture, so
they can be carried-on or re-visited in the future.

## Idea

### Problem Description

The goal is to create a versatile text field model that supports various
input types such as free text, URL, email, telephone, AWS ARN, and both
single-line and multi-line formats. The model should dynamically validate the
input and provide real-time feedback on its validity. Additionally, it should
count characters, words, and lines as the user types. The entire
configuration of the text field should be serializable to JSON, allowing for
easy storage and retrieval of settings. This configuration should include
labels, hints, placeholders, validation rules, informational messages,
warning messages, and error messages. It should also specify the layout
requirements (compact, multi-line) and the direction of the text (RTL or
LTR). Furthermore, the configuration should indicate if an icon is to be
displayed next to the text field and specify which icon.

### Use Cases

1.  **Free Text Input**: A basic text field for any type of text input,
    displaying character, word, and line counts.
2.  **URL Input**: A text field specifically for URLs, with validation rules
    ensuring the input is a valid URL format.
3.  **Email Input**: A text field for email addresses, with appropriate
    validation for email format.
4.  **Telephone Input**: A text field for telephone numbers, with validation
    rules for phone number formats.
5.  **AWS ARN Input**: A text field for AWS ARNs, ensuring the input matches
    the required format for ARNs.
6.  **Multi-Line Input**: A text field that allows multiple lines of text,
    useful for addresses, descriptions, or comments.
7.  **Single-Line Input**: A text field restricted to a single line of text,
    suitable for names, titles, or short inputs.
8.  **Compact Layout**: A text field designed to take minimal space, fitting
    within tight UI constraints.
9.  **RTL Text**: A text field configured for right-to-left text direction,
    necessary for languages such as Arabic or Hebrew.

### Edge Cases

1.  **Empty Input**: Ensure the field correctly handles and validates when
    no input is provided.
2.  **Excessively Long Input**: Handle inputs that exceed typical character
    limits gracefully, displaying an error or truncating.
3.  **Special Characters**: Validate and manage inputs containing special
    characters or symbols.
4.  **Rapid Input Changes**: Accurately update character, word, and line
    counts in real-time as the user types quickly.
5.  **Invalid Formats**: Provide clear error messages for inputs that do not
    meet validation criteria (e.g., incorrect email format).

### Limitations

1.  **Styling and Appearance**: The model should not address detailed
    styling or CSS properties beyond basic layout hints (compact,
    multi-line).
2.  **External API Integrations**: The configuration should not handle or
    define integrations with external APIs for additional validation or data
    fetching.
3.  **Advanced Formatting**: The field should not include advanced formatting
    options like rich text editing or markdown support.
4.  **Non-Text Inputs**: The model should not support non-text inputs such as
    file uploads or date pickers.
5.  **Complex Interdependencies**: The configuration should not handle complex
    interdependencies between multiple fields beyond basic validation rules.

### Examples

1.  **Valid Email Input**: "<example@domain.com>" shows a checkmark
    indicating validity.
2.  **Invalid URL Input**: "htp\://example.com" displays an error message for
    incorrect format.
3.  **Valid Telephone Input**: "+1234567890" displays the phone icon and
    validates successfully.
4.  **Empty AWS ARN Input**: No input shows a warning message to enter an ARN.
5.  **Excessive Characters**: A 500-character input in a field with a
    250-character limit displays an error message.

By clearly defining the problem, use cases, edge cases, and limitations, we
ensure the development of a robust and versatile text field model that meets
diverse requirements and handles a variety of input scenarios effectively.
