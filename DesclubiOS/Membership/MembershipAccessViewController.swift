//
//  MembershipAccessViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 8/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class MembershipAccessViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

	@IBOutlet var commonView: UIView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var nameError: UILabel!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var emailError: UILabel!
	@IBOutlet weak var policyNumber: UITextField!
	@IBOutlet weak var policyNumberError: UILabel!
	@IBOutlet weak var mobileNumber: UITextField!
	@IBOutlet weak var mobileNumberError: UILabel!

    @IBOutlet weak var numberMember: UITextField!

	private var delegate:MembershipBaseUIViewController!
	
	let validator = Validator()
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, delegate:MembershipBaseUIViewController) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.delegate = delegate
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//Looks for single or multiple taps.
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		commonView.addGestureRecognizer(tap)
		
		//move input if keyboard is shown
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
		
		self.email.delegate = self
		self.name.delegate = self
		self.policyNumber.delegate = self
		self.mobileNumber.delegate = self
        self.numberMember.delegate = self
		
		//register validation
		registerValidation()
    }
	
	private func registerValidation(){
		validator.registerField(name, errorLabel: nameError, rules: [RequiredRule(message: "Campo requerido"), FullNameRule(message: "Nombre inválido")])
		validator.registerField(email, errorLabel: emailError, rules: [RequiredRule(message: "Campo requerido"), EmailRule(message: "Correo electrónico inválido")])
		validator.registerField(policyNumber, errorLabel: policyNumberError, rules: [RequiredRule(message: "Campo requerido")/*, BancomerPolicyNumber()*/])
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let value = UIInterfaceOrientation.Portrait.rawValue
		UIDevice.currentDevice().setValue(value, forKey: "orientation")

	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)

	}

	@IBAction func closeModal(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	private func resetFields(){
		name.layer.borderWidth = 0.0
		nameError.hidden = true
		email.layer.borderWidth = 0.0
		emailError.hidden = true
		policyNumber.layer.borderWidth = 0.0
		policyNumberError.hidden = true
		mobileNumber.layer.borderWidth = 0.0
		mobileNumberError.hidden = true
	}
    
    @IBAction func login2(sender: UIButton) {
        
        SwiftSpinner.show("Autenticando", animated: true)
        
        let showValidationError:() -> Void = {
            let alertController = UIAlertController(title: "Error", message:
                "Tus credenciales no son válidas", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        let showValidationAlreadyUsedError:() -> Void = {
            let alertController = UIAlertController(title: "Membresía usada", message:
                "Esta membresía ya ha sido usada. Por favor contacte a soporte@desclub.com", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        /// completion handler for getCorporateMembershipByNumber
        let completionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = { (membershipRepresentation:CorporateMembershipRepresentation?) in
            
            SwiftSpinner.hide()
            
            if let membershipRepresentation = membershipRepresentation {
                magic(membershipRepresentation)
                /*
                 if membershipRepresentation.lastName1?.lowercaseString == self.lastName.text?.lowercaseString {
                 if membershipRepresentation.alreadyUsed != nil && !membershipRepresentation.alreadyUsed! {
                 //success
                 self.successfulMembership(membershipRepresentation)
                 }else{
                 showValidationAlreadyUsedError()
                 }
                 }else{
                 showValidationError()
                 }*/
                self.successfulMembership(membershipRepresentation)
            }else{
                showValidationError()
            }
        }
        
        let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
            SwiftSpinner.hide()
            showValidationError()
        }
        
        // "0011174986802812"
        
        CorporateMembershipFacade.sharedInstance.getCorporateMembershipByNumber(self, number: self.numberMember.text!, completionHandler: completionHandler, errorHandler: errorHandler)
        
    }
	
	func validationSuccessful() {
		
		resetFields()
		
		// submit the form
		
		SwiftSpinner.show("Registrando", animated: true)
		
		let showValidationError:() -> Void = {
			let alertController = UIAlertController(title: "Error", message:
    "Ha ocurrido un error. Inténtalo más tarde", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
		let showValidationAlreadyUsedError:() -> Void = {
			let alertController = UIAlertController(title: "Correo electrónico ya registrado", message:
    "Ya existe una membresía con este correo electrónico. Por favor contacte a soporte@desclub.com", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
		/// completion handler for getCorporateMembershipByNumber
		let completionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = { (membershipRepresentation:CorporateMembershipRepresentation?) in
			
			SwiftSpinner.hide()
			
			if let membershipRepresentation = membershipRepresentation {
					self.successfulMembership(membershipRepresentation)
			}else{
				showValidationError()
			}
		}
		
		let errorHandler: (error: ErrorType?, alreadyRegistered:Bool?) -> Void = { (error:ErrorType?, alreadyRegistered:Bool?) in
			SwiftSpinner.hide()
			
			if let alreadyRegistered = alreadyRegistered {
				if alreadyRegistered {
					showValidationAlreadyUsedError()
				}else{
					showValidationError()
				}
			}else{
				showValidationError()
			}
		}
		
		let membership = CorporateMembershipInputRepresentation(name: name.text!, email: email.text!, policy: policyNumber.text!, mobile: mobileNumber.text!)
		
		CorporateMembershipFacade.sharedInstance.createCorporateMembreship(self, membership: membership, completionHandler: completionHandler, errorHandler: errorHandler)
	}
	
	func validationFailed(errors:[UITextField:ValidationError]) {
		
		resetFields()
		
		// turn the fields to red
		for (field, error) in validator.errors {
			field.layer.borderColor = UIColor.redColor().CGColor
			field.layer.borderWidth = 1.0
			error.errorLabel?.text = error.errorMessage // works if you added labels
			error.errorLabel?.hidden = false
		}
	}
	
	
	@IBAction func login(sender: UIButton) {
		
		validator.validate(self)
		
	}
	
	private func successfulMembership (membershipRepresentation: CorporateMembershipRepresentation) {
		
		/// completion handler for getCorporateMembershipByNumber
		let completionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = { (membershipRepresentation:CorporateMembershipRepresentation?) in
		
			if let membershipRepresentation = membershipRepresentation {
				UserHelper.setCurrentUser(membershipRepresentation)
			}
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
			self.delegate.afterLogin()
			
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			appDelegate.tabBarController.selectedIndex = 3
			
		}
		
		let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
			SwiftSpinner.hide()
		}
		
		let alreadyUsed:CorporateMembershipAlreadyUsedRepresentation = CorporateMembershipAlreadyUsedRepresentation(alreadyUsed: true)
		
		CorporateMembershipFacade.sharedInstance.changeCorporateMembershipStatus(self, membershipId: membershipRepresentation._id!, corporateMembershipAlreadyUsedRepresentation:alreadyUsed,  completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	
	func keyboardWillShow(sender: NSNotification) {
		self.view.frame.origin.y = -100
	}
	func keyboardWillHide(sender: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	//Calls this function when the tap is recognized.
	func dismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		commonView.endEditing(true)
		self.view.frame.origin.y = 0
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	

}
