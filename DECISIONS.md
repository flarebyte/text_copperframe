# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

- a functional requirement (features).
- a non-functional requirement (technologies, methodologies, libraries).

The purpose is to understand the reasons behind the current architecture, so
they can be carried-on or re-visited in the future.

## Image direction

Sleeker image centered around a textarea field with copper outlines,
featuring minimal details like a label, placeholder text, and character/word
count indicators. The design is clean and simple, focusing on the main
textarea field.

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
5.  **Complex Interdependencies**: The configuration should not handle
    complex
    interdependencies between multiple fields beyond basic validation rules.

### Examples

1.  **Valid Email Input**: "<example@domain.com>" shows a checkmark
    indicating validity.
2.  **Invalid URL Input**: "htp\://example.com" displays an error message for
    incorrect format.
3.  **Valid Telephone Input**: "+1234567890" displays the phone icon and
    validates successfully.
4.  **Empty AWS ARN Input**: No input shows a warning message to enter an
    ARN.
5.  **Excessive Characters**: A 500-character input in a field with a
    250-character limit displays an error message.

By clearly defining the problem, use cases, edge cases, and limitations, we
ensure the development of a robust and versatile text field model that meets
diverse requirements and handles a variety of input scenarios effectively.

## Refinements

A Dart model is required to handle a text field widget that includes validation and message display functionality. The text field should dynamically validate input based on specified rules, generating messages at different levels (info, warning, error) as needed. Additionally, the model should support customizable UI behavior through options and allow for merging these options from different sources.

### Use Cases:

1. **Basic Text Validation:**

   - A text field accepts user input and checks if the input is valid based on pre-defined rules (e.g., non-empty, valid email format). Depending on the outcome, an error message may be displayed.

2. **Display Messages with Different Levels:**

   - As the user types, the text field can display messages like "Password too short" (error), "Consider using a stronger password" (warning), or "Password meets requirements" (info).

3. **Event-Driven Validation:**

   - The text field triggers validation rules on specific events (e.g., `onCharChange`, `onBlur`). If a rule fails, the corresponding message is shown to the user.

4. **Optional Icons in Messages:**

   - Messages can optionally include an icon, such as a telephone icon for a "Invalid phone number" error, to provide visual context.

5. **Customizable UI Behavior:**

   - The text field may display additional UI elements based on options, such as showing a character count below the field if the option `displayCharacterCount: true` is provided.

6. **Merging of Options:**
   - The model should allow the merging of global options (e.g., applied to all text fields) with widget-specific options (e.g., unique to one text field). For example, global options might set `displayCharacterCount: true` for all fields, but a specific text field might override this to `false`.

### Edge Cases:

1. **No Matching Rule for Input:**

   - Input that does not trigger any validation rules should result in no messages being displayed.

2. **Multiple Messages from a Single Event:**

   - A single input event might trigger multiple validation rules, potentially resulting in multiple messages of different levels being displayed simultaneously.

3. **Conflicting UI Options:**

   - When global and widget-specific options conflict, the model should clearly define which options take precedence (e.g., widget-specific options override global options).

4. **Message Update Frequency:**

   - Messages should update in real-time as the user types, but care should be taken to avoid excessive re-rendering or flickering of the UI.

5. **Handling Undefined Events:**

   - If an event is triggered for which no rules are defined, the system should safely ignore the event without producing errors or unexpected behavior.

6. **Icon Availability:**
   - Ensure that the absence of an icon for a message does not lead to UI layout issues.

### Limitations:

1. **Non-Visual Elements:**

   - The model should not address the specific visual styling of messages or the text field; it should focus only on validation logic and message handling.

2. **Complex Validation Logic:**

   - The model should not implement complex validation logic such as asynchronous validation (e.g., server-side checks), focusing only on simple, synchronous validation rules.

3. **Event-Driven Logic Beyond Validation:**

   - The model should not handle events unrelated to validation, such as keybinding or form submission events.

4. **Extensive UI Customization:**

   - The model should not attempt to offer extensive customization of the UI beyond the simple option-based modifications like `displayCharacterCount`.

5. **Global State Management:**
   - The model should not manage or store global state outside of the context of the text field's validation and option handling.

### Summary:

The model should focus on validating user input in a Dart text field widget, generating contextually appropriate messages based on a set of predefined rules triggered by specific events. It should allow for some basic UI customization through a flexible options system, and provide a mechanism to merge different sets of options together, ensuring a smooth and user-friendly experience.
