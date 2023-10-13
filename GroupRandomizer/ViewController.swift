//
//  ViewController.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 29.09.2023.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private var allGroups: [Group] = Storage.shared.getAllGroups()
    private var currentGroup: Group?
    private var currentEvent: Event?
    private var currentStudentIndex: Int?
    private var alreadyUsedIndexies: [Int] = []
    private var header = "Set event name!\n\n"
    private lazy var groupMenu = UIMenu(title: "All groups", children: groupMenuElements)
    private lazy var groupMenuElements: [UIMenuElement] = []
    private lazy var setupMenu = UIMenu(title: "Setup", children: setupMenuElements)
    private lazy var setupMenuElements: [UIMenuElement] = []
    
    // UI Elements
    private lazy var groupNameButton: UIButton = {
        let groupButton = UIButton()
        groupButton.setTitle("Chose group and set name for", for: .normal)
        groupButton.backgroundColor = .blue
        groupButton.setTitleColor(.cyan, for: .normal)
        groupButton.layer.cornerRadius = 15
        groupButton.showsMenuAsPrimaryAction = true
        groupButton.menu = groupMenu
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        return groupButton
    }()

    private lazy var setupButton: UIButton = {
        let setupButton = UIButton()
        setupButton.setTitle("event", for: .normal)
        setupButton.backgroundColor = .purple
        setupButton.setTitleColor(.cyan, for: .normal)
        setupButton.layer.cornerRadius = 15
        setupButton.showsMenuAsPrimaryAction = true
        setupButton.menu = setupMenu
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        return setupButton
    }()
    
    private lazy var namesOfStudentsText: UITextView = {
        let nameLabel = UITextView()
        nameLabel.text = ""
        nameLabel.textColor = .blue
        nameLabel.backgroundColor = .cyan
        nameLabel.isUserInteractionEnabled = true
        nameLabel.isEditable = false
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.layer.cornerRadius = 15
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var switchDescription: UILabel = {
        let label = UILabel()
        label.text = "Ask twice"
        label.textColor = .blue
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = .italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var askTwiceSwitch: UISwitch = {
        let view = UISwitch()
        view.contentMode = .scaleToFill
        view.contentHorizontalAlignment = .center
        view.contentVerticalAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var groupTaskButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "book") ?? UIImage(),
            target: self,
            action: #selector(Self.showGroupTaskButton)
        )

        button.tintColor = .green
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "repeat") ?? UIImage(),
            target: self,
            action: #selector(Self.restartButtonTapped)
        )

        button.tintColor = .green
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "checkmark") ?? UIImage(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .green
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var crossButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "multiply") ?? UIImage(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var studentInfoButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "person") ?? UIImage(),
            target: self,
            action: #selector(Self.showStudentInfo)
        )

        button.tintColor = .green
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chosenStudent: UIButton = {
        let button = UIButton()
        let label = UILabel()
        button.setTitle("Tap to chose random student", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.cyan, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(Self.didTapChooseRandomButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGroupMenuElements()
        configureSetupMenuElements()
        addSubViews()
        applyConstraints()
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(groupNameButton)
        view.addSubview(setupButton)
        view.addSubview(switchDescription)
        view.addSubview(askTwiceSwitch)
        view.addSubview(groupTaskButton)
        view.addSubview(restartButton)
        view.addSubview(studentInfoButton)
        view.addSubview(namesOfStudentsText)
        view.addSubview(chosenStudent)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            groupNameButton.heightAnchor.constraint(equalToConstant: 40),
            groupNameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupNameButton.trailingAnchor.constraint(equalTo: setupButton.leadingAnchor , constant: -4),
            groupNameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            setupButton.heightAnchor.constraint(equalToConstant: 40),
            setupButton.leadingAnchor.constraint(equalTo: groupNameButton.trailingAnchor),
            setupButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            setupButton.topAnchor.constraint(equalTo: groupNameButton.topAnchor),
            setupButton.bottomAnchor.constraint(equalTo: groupNameButton.bottomAnchor),
            
            switchDescription.heightAnchor.constraint(equalToConstant: 20),
            switchDescription.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            switchDescription.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            switchDescription.topAnchor.constraint(equalTo: setupButton.bottomAnchor, constant: 10),
            
            askTwiceSwitch.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            askTwiceSwitch.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            askTwiceSwitch.topAnchor.constraint(equalTo: switchDescription.bottomAnchor, constant: 4),
            
            groupTaskButton.widthAnchor.constraint(equalToConstant: 70),
            groupTaskButton.heightAnchor.constraint(equalToConstant: 70),
            groupTaskButton.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            groupTaskButton.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            groupTaskButton.topAnchor.constraint(equalTo: askTwiceSwitch.bottomAnchor, constant: 20),
            
            restartButton.widthAnchor.constraint(equalToConstant: 70),
            restartButton.heightAnchor.constraint(equalToConstant: 70),
            restartButton.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            restartButton.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            restartButton.topAnchor.constraint(equalTo: groupTaskButton.bottomAnchor, constant: 4),
            
            studentInfoButton.widthAnchor.constraint(equalToConstant: 70),
            studentInfoButton.heightAnchor.constraint(equalToConstant: 70),
            studentInfoButton.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            studentInfoButton.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            studentInfoButton.bottomAnchor.constraint(equalTo: chosenStudent.topAnchor, constant: -4),
            
            chosenStudent.heightAnchor.constraint(equalToConstant: 50),
            chosenStudent.leadingAnchor.constraint(equalTo: groupNameButton.leadingAnchor),
            chosenStudent.trailingAnchor.constraint(equalTo: groupTaskButton.trailingAnchor),
            chosenStudent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            namesOfStudentsText.leadingAnchor.constraint(equalTo: groupNameButton.leadingAnchor),
            namesOfStudentsText.trailingAnchor.constraint(equalTo: groupNameButton.trailingAnchor),
            namesOfStudentsText.topAnchor.constraint(equalTo: groupNameButton.bottomAnchor, constant: 4),
            namesOfStudentsText.bottomAnchor.constraint(equalTo: chosenStudent.topAnchor, constant: -4)
        ])
    }
    
    private func showStudents(from sortedStudents: [Student]) {
        var count: Int = 1
        var list: String = ""
        for student in sortedStudents {
            list += "\(count). \(student.name) \n"
            count += 1
        }
        currentEvent?.eventResult = list
        namesOfStudentsText.text = header + list
    }
    
    private func configureGroupMenuElements() {
        for group in sortItems(allGroups) {
            let action = UIAction(title: group.groupName) { action in
                self.currentGroup = group
                self.currentStudentIndex = nil
                self.alreadyUsedIndexies = []
                self.header = "Set event name!\n\n"
                self.currentEvent = Event()
                self.chosenStudent.setTitle("Tap to chose random student", for: .normal)
                self.groupNameButton.setTitle(group.groupName, for: .normal)
                let sortedStudents = self.sortItems(group)
                self.showStudents(from: sortedStudents)
            }
            
            groupMenuElements.append(action)
        }
        
        let createAction = UIAction(title: "Add new group...") { action in
        print("Create new group")
            self.namesOfStudentsText.text = "Enter name of new group:\n>\nEnter members:\n"
            self.showSaveButton()
            self.showCrossButton()
            self.saveButton.addTarget(self, action: #selector(Self.createNewGroup), for: .touchUpInside)
            self.crossButton.addTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
        }
        
        let redactAction = UIAction(title: "Edit this group") { action in
        print("Edit this group")
            if let currentGroup = self.currentGroup {
                
                self.namesOfStudentsText.text = "Enter new name of this group:\n>\nNew band lineup:\n"
                for student in currentGroup.students {
                    self.namesOfStudentsText.text += student.name + "\n"
                }
                self.showSaveButton()
                self.showCrossButton()
                self.saveButton.addTarget(self, action: #selector(Self.editGroup), for: .touchUpInside)
                self.crossButton.addTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
            } else {
                self.namesOfStudentsText.text = "select the group you want to edit"
            }
        }
        
        let deleteAction = UIAction(title: "Delete this group") { action in
            if self.currentGroup != nil {
                self.namesOfStudentsText.text = "Do you really want delete this group?"
                self.showSaveButton()
                self.showCrossButton()
                self.saveButton.addTarget(self, action: #selector(Self.deleteGroup), for: .touchUpInside)
                self.crossButton.addTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
            } else {
                self.namesOfStudentsText.text = "select the group you want to delete"
            }
        }
        
        groupMenuElements.append(createAction)
        groupMenuElements.append(redactAction)
        groupMenuElements.append(deleteAction)
    }
    
    private func configureSetupMenuElements() {
        let setupAction1 = UIAction(title: "Set event name") { action in
            if let currentGroup = self.currentGroup {
                self.namesOfStudentsText.text = "Enter event name:\n"
                self.showSaveButton()
                self.saveButton.addTarget(self, action: #selector(Self.saveEventName), for: .touchUpInside)
            } else {
                self.namesOfStudentsText.text = "Choose group at first!"
            }
        }

        let setupAction2 = UIAction(title: "Redact current result") { action in
            if let currentGroup = self.currentGroup,
               let currentEvent = self.currentEvent {
                self.namesOfStudentsText.text = currentEvent.eventResult
                self.showSaveButton()
                self.saveButton.addTarget(self, action: #selector(Self.redactCurrentResult), for: .touchUpInside)
            } else {
                self.namesOfStudentsText.text = "Choose group at first!"
            }
        }
        
        let setupAction3 = UIAction(title: "Tag epsent persons") { action in
            if self.currentGroup != nil {
                //TODO: handle
            } else {
                self.namesOfStudentsText.text = "Choose group at first!"
            }
        }
        
        let setupAction4 = UIAction(title: "Save current session") { action in
            if let currentGroup = self.currentGroup,
               let currentEvent = self.currentEvent {
                if currentEvent.eventName != "empty event name" {
                    currentGroup.events.append(currentEvent)
                    Storage.shared.saveData(self.allGroups)
                    self.namesOfStudentsText.text = "The result has been successfully saved, to continue select a group and create an event"
                    self.currentGroup = nil
                    self.currentEvent = nil
                    self.currentStudentIndex = nil
                    self.alreadyUsedIndexies = []
                } else {
                    self.namesOfStudentsText.text = "Rename your event"
                    self.makeButtonsInactive([self.studentInfoButton, self.restartButton, self.groupTaskButton, self.chosenStudent, self.groupNameButton])
                }
            } else {
                self.namesOfStudentsText.text = "Choose group and create an event at first!"
            }
        }
        
        setupMenuElements.append(setupAction1)
        setupMenuElements.append(setupAction2)
        setupMenuElements.append(setupAction3)
        setupMenuElements.append(setupAction4)
    }
    
    @objc private func createNewGroup() {
        let text = namesOfStudentsText.text
        guard let text = text else { return }
        let textOfGroupName = text.components(separatedBy: ">").last?.components(separatedBy: "\n").first
        guard let textOfGroupName = textOfGroupName else { return }
        var groupName = ""
        if !textOfGroupName.isEmpty {
            groupName = textOfGroupName
        }
        
        let textOfStudentsNames = text.components(separatedBy: "Enter members:\n").last
        guard let textOfStudentsNames = textOfStudentsNames else { return }
        
        let studentNamesArray = textOfStudentsNames.components(separatedBy: "\n").sorted { $0 < $1 }
        var studentsArray: [Student] = []
        var groupsNamesArray: [String] = []
        
        for group in allGroups {
            groupsNamesArray.append(group.groupName)
        }
        
        let groupNameIsUnique = !groupsNamesArray.contains(groupName)
        let allMembersNamesIsUnique = studentNamesArray.count == Set(studentNamesArray).count
        
        for row in studentNamesArray {
            if !row.isEmpty && row.trimmingCharacters(in: .whitespaces) != "" {
                studentsArray.append(Student(name: row))
            }
        }
        
        if !groupName.isEmpty &&
            groupName.trimmingCharacters(in: .whitespaces) != "" &&
            !studentsArray.isEmpty &&
            groupNameIsUnique &&
            allMembersNamesIsUnique {
            let newGroup = Group(groupName: groupName, students: studentsArray)
            
            allGroups.append(newGroup)
            Storage.shared.saveData(allGroups)
            
            currentGroup = newGroup
            restartGame()
            saveButton.removeTarget(self, action: #selector(Self.createNewGroup), for: .touchUpInside)
            crossButton.removeTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
            hideSaveButton()
            hideCrossButton()
            //TODO: добавить в GroupName группу. перерисовать namesText
        } else {
            let message = "The group name and students names must be unique, cannot be blank or consist entirely of spaces.\n The group must consist of at least one member."
            AlertPresenter(onViewController: self).showAlert(message: message)
        }
    }
    
    @objc private func editGroup() {
        guard let currentGroup = currentGroup else { return }
        let text = namesOfStudentsText.text
        guard let text = text else { return }
        let textOfGroupName = text.components(separatedBy: ">").last?.components(separatedBy: "\n").first
        guard let textOfGroupName = textOfGroupName else { return }
        var newGroupName = currentGroup.groupName
        if !textOfGroupName.isEmpty && textOfGroupName.trimmingCharacters(in: .whitespaces) != "" {
            newGroupName = textOfGroupName
        }
        
        let textOfStudentsNames = text.components(separatedBy: "New band lineup:\n").last
        guard let textOfStudentsNames = textOfStudentsNames else { return }
        
        let newStudentNamesArray = textOfStudentsNames.components(separatedBy: "\n").sorted { $0 < $1 }
        let allStudentNamesIsUnique = newStudentNamesArray.count == Set(newStudentNamesArray).count
        var addedStudentsArray: [Student] = []
        var oldStudentNames: [String] = []
        
        if !newStudentNamesArray.isEmpty && allStudentNamesIsUnique {
            for student in currentGroup.students {
                oldStudentNames.append(student.name)
            }
            
            let difference = newStudentNamesArray.difference(from: oldStudentNames)
            for change in difference {
                switch change {
                case let .remove(_, oldElement, _):
                    currentGroup.students.removeAll(where: {$0.name == oldElement})
                case let .insert(_, newElement, _):
                    if newElement.trimmingCharacters(in: .whitespaces) != "" {
                        addedStudentsArray.append(Student(name: newElement))
                    }
                }
            }
            
            currentGroup.students.append(contentsOf: addedStudentsArray)
            if !currentGroup.students.isEmpty {
                allGroups.removeAll(where: {$0.groupName == currentGroup.groupName})
                currentGroup.groupName = newGroupName
                allGroups.append(currentGroup)
                Storage.shared.saveData(allGroups)
            } else {
                let message = "the group must consist of at least one member."
                AlertPresenter(onViewController: self).showAlert(message: message)
            }
            
        } else {
            let message = "Students names must be unique, cannot be blank or consist entirely of spaces."
            AlertPresenter(onViewController: self).showAlert(message: message)
        }

        saveButton.removeTarget(self, action: #selector(Self.editGroup), for: .touchUpInside)
        crossButton.removeTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
        hideSaveButton()
        hideCrossButton()
        restartGame()
    }
    
    @objc private func deleteGroup() {
        guard let currentGroup = currentGroup else { return }
        allGroups.removeAll(where: {$0.groupName == currentGroup.groupName})
        
        Storage.shared.saveData(allGroups)
        
        self.currentGroup = nil
        saveButton.removeTarget(self, action: #selector(Self.deleteGroup), for: .touchUpInside)
        crossButton.removeTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
        hideSaveButton()
        hideCrossButton()
        restartGame()
        //TODO: убрать из GroupName удаленные группы. перерисовать namesText
    }
    
    @objc private func dismissSavingChanges() {
        restartGame()
        saveButton.removeTarget(self, action: #selector(Self.createNewGroup), for: .touchUpInside)
        crossButton.removeTarget(self, action: #selector(Self.dismissSavingChanges), for: .touchUpInside)
        hideSaveButton()
        hideCrossButton()
    }
    
    @objc private func didTapChooseRandomButton(_ sender: UIButton) {
        guard let currentGroup = currentGroup else { return }

        if askTwiceSwitch.isOn && alreadyUsedIndexies.count == currentGroup.students.count {
            alreadyUsedIndexies = []
        }
        
        if currentGroup.students.count == alreadyUsedIndexies.count {
            chosenStudent.setTitle("You've already interviewed all members", for: .normal)
            return
        } else {
            let studentIndicies = currentGroup.students.indices
            let leftedIndicies = studentIndicies.filter({ !alreadyUsedIndexies.contains($0)})
            let index = leftedIndicies.randomElement()!
            currentStudentIndex = index
            let happyStudent = currentGroup.students[index]
            
            showTag(name: happyStudent.name)
            chosenStudent.setTitle(happyStudent.name, for: .normal)
            alreadyUsedIndexies.append(index)
        }
    }
    
    private func showTag(name: String) {
        var string = currentEvent?.eventResult
        if let range = string?.range(of: name) {
            string?.insert(contentsOf: " ✅", at: range.upperBound)
        }
        
        currentEvent?.eventResult = string
        namesOfStudentsText.text = header + (currentEvent?.eventResult ?? "empty event result or current event")
    }
    
    @objc private func saveEventName() {
        guard let string = namesOfStudentsText.text else {
            return
        }
        
        let subString: String? = string.components(separatedBy: "Enter event name:\n").last
        guard let subString = subString else {
            return
        }
        
        var newEventName = ""
        if subString.isEmpty {
            newEventName = "empty event name"
        } else {
            newEventName = subString
        }
        
        guard let currentEvent = currentEvent else { return }
        header = "event: \(newEventName)\ndate: \(currentEvent.eventDate.dateTimeString)\n*  *  *  *  §  *  *  *  *\n"
        currentEvent.eventName = newEventName
        guard let currentResult = currentEvent.eventResult else {
            namesOfStudentsText.text = header
            return
        }
        
        namesOfStudentsText.text = header + currentResult
        saveButton.removeTarget(self, action: #selector(Self.saveEventName), for: .touchUpInside)
        hideSaveButton()
    }
    
    @objc private func redactCurrentResult() {
        guard let string = namesOfStudentsText.text else {
            return
        }
        
        currentEvent?.eventResult = string
        guard let currentResult = currentEvent?.eventResult else { return }
        namesOfStudentsText.text = header + currentResult
        saveButton.removeTarget(self, action: #selector(Self.redactCurrentResult), for: .touchUpInside)
        hideSaveButton()
    }
    
    @objc private func showGroupTaskButton(_ sender: UIButton) {
        if currentGroup != nil {
            namesOfStudentsText.isEditable = true
            makeButtonsInactive([studentInfoButton, restartButton, chosenStudent, groupNameButton, setupButton])
            guard let currentGroup = currentGroup else { return }
            if currentGroup.groupTask == nil {
                namesOfStudentsText.text = "Enter tasks for this group:\n"
            } else {
                namesOfStudentsText.text = currentGroup.groupTask
            }
            
            groupTaskButton.setImage(UIImage(systemName: "opticaldisc") ?? UIImage(), for: .normal)
            groupTaskButton.removeTarget(self, action: #selector(Self.showGroupTaskButton), for: .touchUpInside)
            groupTaskButton.addTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
        }
    }
    
    @objc private func saveGroupTask(_ sender: UIButton) {
        guard let currentGroup = currentGroup else { return }
        currentGroup.groupTask = namesOfStudentsText.text
        namesOfStudentsText.isEditable = false
        makeButtonsActive([studentInfoButton, restartButton, chosenStudent, groupNameButton, setupButton])
        groupTaskButton.setImage(UIImage(systemName: "book") ?? UIImage(), for: .normal)
        groupTaskButton.removeTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
        groupTaskButton.addTarget(self, action: #selector(Self.showGroupTaskButton), for: .touchUpInside)
        namesOfStudentsText.text = header + (currentEvent?.eventResult ?? "")
    }
    
    @objc private func showStudentInfo(_ sender: UIButton) {
        if  currentStudentIndex != nil {
            namesOfStudentsText.isEditable = true
            makeButtonsActive([studentInfoButton])
            makeButtonsInactive([restartButton, groupTaskButton, chosenStudent, groupNameButton, setupButton])
            guard let currentGroup = currentGroup else { return }
            guard let currentStudentIndex = currentStudentIndex else { return }
            namesOfStudentsText.text = currentGroup.students[currentStudentIndex].marks ?? currentGroup.students[currentStudentIndex].name + " info:\n"
            studentInfoButton.setImage(UIImage(systemName: "opticaldisc") ?? UIImage(), for: .normal)
            studentInfoButton.removeTarget(self, action: #selector(Self.showStudentInfo), for: .touchUpInside)
            studentInfoButton.addTarget(self, action: #selector(Self.saveStudentInfo), for: .touchUpInside)
        }
    }
    
    @objc private func saveStudentInfo(_ sender: UIButton) {
        guard let currentStudentIndex = currentStudentIndex else { return }
        guard let currentGroup = currentGroup else { return }
        currentGroup.students[currentStudentIndex].marks = namesOfStudentsText.text
        namesOfStudentsText.isEditable = false
        makeButtonsActive([studentInfoButton, restartButton, groupTaskButton, chosenStudent, groupNameButton, setupButton])
        namesOfStudentsText.text = header + (currentEvent?.eventResult ?? "")
        studentInfoButton.setImage(UIImage(systemName: "person") ?? UIImage(), for: .normal)
        studentInfoButton.removeTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
        studentInfoButton.addTarget(self, action: #selector(Self.showStudentInfo), for: .touchUpInside)
    }
    
    @objc private func restartButtonTapped(_ sender: UIButton) {
        restartGame()
    }
    
    private func restartGame() {
        alreadyUsedIndexies = []
        currentStudentIndex = nil
        currentEvent = Event()
        header = "Set event name!\n\n"
        chosenStudent.setTitle("Tap to chose random student", for: .normal)
        guard let currentGroup = currentGroup else {
            namesOfStudentsText.text = ""
            groupNameButton.setTitle("Chose group and set name for", for: .normal)
            return
        }
        groupNameButton.setTitle(currentGroup.groupName, for: .normal)
        showStudents(from: sortItems(currentGroup))
    }
}

//MARK: - Helpers
extension ViewController {
    private func makeButtonsInactive(_ elements: [UIButton]) {
        for element in elements {
            element.isUserInteractionEnabled = false
        }
    }
    
    private func makeButtonsActive(_ elements: [UIButton]) {
        for element in elements {
            element.isUserInteractionEnabled = true
        }
    }
    
    private func sortItems(_ allGroups: [Group]) -> [Group] {
        return allGroups.sorted { $0.groupName < $1.groupName }
    }
    
    private func sortItems(_ currentGroup: Group) -> [Student] {
        return currentGroup.students.sorted { $0.name < $1.name }
    }
    
    private func showSaveButton() {
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 70),
            saveButton.heightAnchor.constraint(equalToConstant: 150),
            saveButton.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            saveButton.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            saveButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 50)
        ])
        
        namesOfStudentsText.isEditable = true
        makeButtonsInactive([studentInfoButton, restartButton, groupTaskButton, chosenStudent, groupNameButton, setupButton])
    }
    
    private func showCrossButton() {
        view.addSubview(crossButton)
        NSLayoutConstraint.activate([
            crossButton.widthAnchor.constraint(equalToConstant: 70),
            crossButton.heightAnchor.constraint(equalToConstant: 70),
            crossButton.trailingAnchor.constraint(equalTo: setupButton.trailingAnchor),
            crossButton.leadingAnchor.constraint(equalTo: setupButton.leadingAnchor),
            crossButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30)
        ])
    }
    
    private func hideSaveButton() {
        saveButton.removeFromSuperview()
        
        namesOfStudentsText.isEditable = false
        makeButtonsActive([studentInfoButton, restartButton, groupTaskButton, chosenStudent, groupNameButton, setupButton])
    }
    
    private func hideCrossButton() {
        crossButton.removeFromSuperview()
        saveButton.removeFromSuperview()
        
        namesOfStudentsText.isEditable = false
        makeButtonsActive([studentInfoButton, restartButton, groupTaskButton, chosenStudent, groupNameButton, setupButton])
    }
}

