## Set main PDDL domain file
#set($pddlDomainElement = $elementScope.get(0))

## Check if element scope has stereotype PDDL_Domainfile
#if(!$report.containsStereotype($pddlDomainElement, "PDDL_Domain")) 
ERROR: SCOPE IS NO "PDDL_Domainfile"
#else

## Set domain name variable from SysML model
#set($pddlDomainName = $pddlDomainElement.name)

(define (domain $pddlDomainName)

    (:requirements :typing :negative-preconditions :fluents)

    (:types
    #foreach($typeElement in $pddlDomainElement.types)
        #set($currentTypeElement = $typeElement)

        ## Recursive function to handle all levels of subtypes
        #macro (generateTypeHierarchy $parentTypeElement)
            #foreach($subtypeElement in $parentTypeElement.subtype)
                $subtypeElement.name - $parentTypeElement.name
                #generateTypeHierarchy($subtypeElement) ## Recursive call for further subtypes
            #end
        #end

        ## Call the macro for the current type
        #generateTypeHierarchy($currentTypeElement)
    #end
    )

    (:predicates
    #foreach($predicateElement in $pddlDomainElement.predicates)
        #set($predicateName = $predicateElement.predicatename)
        ## Check if predicate has a name and parts before proceeding
        #if($predicateName && $predicateElement.predicatepart)
            ($predicateName 
            #foreach($predicatePart in $predicateElement.predicatepart)
                #set($variableName = $predicatePart.variable.variable)
                #set($variableTypeName = $predicatePart.variabletype.name)
                #if($variableName && $variableTypeName) 
                    $variableName - $variableTypeName 
                #else 
                    ERROR: MISSING VARIABLE OR VARIABLE TYPE FOR PREDICATE $predicateName
                #end
            #end) 
        #else
            ERROR: PREDICATE $predicateElement IS MISSING NAME OR PARTS
        #end
    #end
    )

    (:functions 
        (total-cost) - number
        #foreach($functionElement in $pddlDomainElement.functions)
            #set($functionName = $functionElement.functionname)
            ## Check if function name and parts are defined
            #if($functionName && $functionElement.functionpart)
                ($functionName 
                #foreach($functionPart in $functionElement.functionpart)
                    #set($functionVariableName = $functionPart.variable.variable)
                    #set($functionVariableTypeName = $functionPart.variabletype.name)
                    #if($functionVariableName && $functionVariableTypeName) 
                        $functionVariableName - $functionVariableTypeName 
                    #else 
                        ERROR: MISSING VARIABLE OR VARIABLE TYPE FOR FUNCTION $functionName
                    #end
                #end)
            #else
                ERROR: FUNCTION $functionElement IS MISSING NAME OR PARTS
            #end
        #end
    )

    ## Action Generation
    #foreach ($actionElement in $pddlDomainElement.action)
        #set($actionName = $actionElement.name)
        ## Check if action has a name and defined parameters, preconditions, and effects
        #if($actionName && $actionElement.parameters && $actionElement.precondition && $actionElement.effect)

        (:action $actionName
            ## Generate parameters with type checking
            :parameters (#foreach($parameterElement in $actionElement.parameters)
                            #set($parameterName = $parameterElement.variablename.variable)
                            #set($parameterTypeName = $parameterElement.variable_is_of_type.name)
                            #if($parameterName && $parameterTypeName)
                                $parameterName - $parameterTypeName
                            #else
                                ERROR: MISSING PARAMETER NAME OR TYPE FOR ACTION $actionName
                            #end
                        #end)
            
            ## Generate preconditions
            #set($preconditions = "")
            #set($preconditionCount = 0)
            #foreach($preconditionElement in $actionElement.precondition.predicates_have_to_be_true.predicates_are_switched)
                #set($preconditionPredicateName = $preconditionElement.predicatename.predicatename)
                #if($preconditionPredicateName)
                    #if($preconditionElement.inverse) 
                        #set($preconditions = "$preconditions (not ($preconditionPredicateName #foreach($parameter in $preconditionElement.parameter) $parameter.variable #end))")
                    #else
                        #set($preconditions = "$preconditions ($preconditionPredicateName #foreach($parameter in $preconditionElement.parameter) $parameter.variable #end)")
                    #end
                    #set($preconditionCount = $preconditionCount + 1)
                #else
                    ERROR: MISSING PREDICATE NAME FOR PRECONDITION IN ACTION $actionName
                #end
            #end

            #if($preconditionCount > 1)
                :precondition (and $preconditions)
            #elseif($preconditionCount == 1)
                :precondition $preconditions
            #end

            ## Generate effects
            #set($effects = "")
            #set($effectCount = 0)
            #foreach($effectElement in $actionElement.effect.logical_expression.predicates_are_switched)
                #set($effectPredicateName = $effectElement.predicatename.predicatename)
                #if($effectPredicateName)
                    #if($effectElement.inverse)
                        #set($effects = "$effects (not ($effectPredicateName #foreach($effectParameter in $effectElement.parameter) $effectParameter.variable #end))")
                    #else
                        #set($effects = "$effects ($effectPredicateName #foreach($effectParameter in $effectElement.parameter) $effectParameter.variable #end)")
                    #end
                    #set($effectCount = $effectCount + 1)
                #else
                    ERROR: MISSING PREDICATE NAME FOR EFFECT IN ACTION $actionName
                #end
            #end

            #if($effectCount > 1)
                :effect (and $effects)
            #elseif($effectCount == 1)
                :effect $effects
            #end
        )

        #else
            ERROR: ACTION $actionElement IS MISSING NAME, PARAMETERS, PRECONDITIONS, OR EFFECTS
        #end
    #end
)

#end
