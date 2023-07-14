public class InvokeFlow {

	{
          Map<String, Object> inputs = new Map<String, Object>();
          inputs.put('var_case','comment' );
          inputs.put('var_IsPublished', true);
          inputs.put('CaseCommenExtensionID', '12345');
          Flow.Interview.CaseCommentExtensionCreation myFlow = new Flow.Interview.CaseCommentExtensionCreation(inputs);    
          myFlow.start();
	}

    
}