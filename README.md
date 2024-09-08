# VTL Template for PDDL Domain File Generation

This repository provides a Velocity Template Language (VTL) template designed to automate the generation of PDDL domain files from SysML-based system models. The template is integrated into model-based systems engineering (MBSE) tools like Magic Systems of Systems Architect (MSOSA) and facilitates the automated conversion of system model information into syntactically correct and semantically meaningful PDDL domain files for use in AI planning.

## Features

- **Automated PDDL Domain File Generation:** Extracts actions, predicates, and types from SysML models and generates PDDL domain files.
- **Precondition and Effect Handling:** Automatically defines preconditions and effects for actions based on SysML model annotations.
- **Error Checking:** Includes checks for missing parameters, names, or predicates to prevent incomplete or incorrect PDDL files.
- **Extensible Template:** Easily customizable for different planning problems and domain configurations.

## Prerequisites

To use this template, you will need:
- **SysML Model:** A SysML-based system model annotated with the PDDL profile (https://github.com/hsu-aut/SysML-Profile-PDDL).
- **MBSE Software like Magic Systems of Systems Architect (MSOSA):** The template integrates directly with the Velocity Engine embedded in MSOSA. 

## Usage

1. **Setup the SysML Model:**
   - Ensure that your SysML model is enriched with the PDDL profile. This includes annotating all necessary elements (actions, predicates, types) with the corresponding PDDL stereotypes.

2. **Configure the Template:**
   - Modify the `pddlDomainElement` in the template to reference your SysML domain elements.

3. **Run the Template:**
   - Use the integrated Velocity Engine in MSOSA or another supported tool to execute the VTL template.
   - The template will generate a PDDL domain file, which includes types, predicates, and actions automatically extracted from the SysML model.

4. **Verify the Output:**
   - The generated PDDL domain file will contain all the necessary definitions for use in a PDDL solver, including actions, parameters, preconditions, and effects.
