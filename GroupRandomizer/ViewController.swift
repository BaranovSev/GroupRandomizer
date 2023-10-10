//
//  ViewController.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 29.09.2023.
//

import UIKit

var allGroups: [Group] = Storage.shared.getAllGroups()
private var currentGroup: Group = allGroups[1]

class ViewController: UIViewController {
    // MARK: - Properties
    private var currentStudentIndex: Int?
    private var alreadyUsedIndexies: [Int] = []
    private var lastText: String?
    // UI Elements
    private lazy var groupNameButton: UIButton = {
        let groupButton = UIButton()
        let label = UILabel()
        groupButton.setTitle(currentGroup.groupName, for: .normal)
        groupButton.backgroundColor = .blue
        groupButton.setTitleColor(.cyan, for: .normal)
        groupButton.layer.cornerRadius = 15
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        return groupButton
    }()

    private lazy var presentStudentsButton: UIButton = {
        let groupButton = UIButton()
        let label = UILabel()
        groupButton.setTitle("15/30", for: .normal)
        groupButton.backgroundColor = .purple
        groupButton.setTitleColor(.cyan, for: .normal)
        groupButton.layer.cornerRadius = 15
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        return groupButton
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
        addSubViews()
        applyConstraints()
        
        let sortedGroupsNames = sortItems(allGroups)
        let sortedStudents = sortItems(currentGroup)
        
        showStudents(from: sortedStudents)
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(groupNameButton)
        view.addSubview(presentStudentsButton)
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
            groupNameButton.trailingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor , constant: -4),
            groupNameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            presentStudentsButton.heightAnchor.constraint(equalToConstant: 40),
            presentStudentsButton.leadingAnchor.constraint(equalTo: groupNameButton.trailingAnchor),
            presentStudentsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            presentStudentsButton.topAnchor.constraint(equalTo: groupNameButton.topAnchor),
            presentStudentsButton.bottomAnchor.constraint(equalTo: groupNameButton.bottomAnchor),
            
            switchDescription.heightAnchor.constraint(equalToConstant: 20),
            switchDescription.trailingAnchor.constraint(equalTo: presentStudentsButton.trailingAnchor),
            switchDescription.leadingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor),
            switchDescription.topAnchor.constraint(equalTo: presentStudentsButton.bottomAnchor, constant: 10),
            
            askTwiceSwitch.trailingAnchor.constraint(equalTo: presentStudentsButton.trailingAnchor),
            askTwiceSwitch.leadingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor),
            askTwiceSwitch.topAnchor.constraint(equalTo: switchDescription.bottomAnchor, constant: 4),
            
            groupTaskButton.widthAnchor.constraint(equalToConstant: 70),
            groupTaskButton.heightAnchor.constraint(equalToConstant: 70),
            groupTaskButton.trailingAnchor.constraint(equalTo: presentStudentsButton.trailingAnchor),
            groupTaskButton.leadingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor),
            groupTaskButton.topAnchor.constraint(equalTo: askTwiceSwitch.bottomAnchor, constant: 20),
            
            restartButton.widthAnchor.constraint(equalToConstant: 70),
            restartButton.heightAnchor.constraint(equalToConstant: 70),
            restartButton.trailingAnchor.constraint(equalTo: presentStudentsButton.trailingAnchor),
            restartButton.leadingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor),
            restartButton.topAnchor.constraint(equalTo: groupTaskButton.bottomAnchor, constant: 4),
            
            studentInfoButton.widthAnchor.constraint(equalToConstant: 70),
            studentInfoButton.heightAnchor.constraint(equalToConstant: 70),
            studentInfoButton.trailingAnchor.constraint(equalTo: presentStudentsButton.trailingAnchor),
            studentInfoButton.leadingAnchor.constraint(equalTo: presentStudentsButton.leadingAnchor),
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
    
    private func sortItems(_ allGroups: [Group]) -> [String] {
        var names: [String] = []
        for group in allGroups {
            names.append(group.groupName)
        }
        
        return names.sorted { $0 < $1 }
    }
    
    private func sortItems(_ currentGroup: Group) -> [Student] {
        return currentGroup.students.sorted { $0.name < $1.name }
    }
    
    private func showStudents(from sortedStudents: [Student]) {
        var count: Int = 1
        var list: String = ""
        for student in sortedStudents {
            list += "\(count). \(student.name) \n"
            count += 1
        }
        
        namesOfStudentsText.text = list
    }
    
    @objc private func didTapChooseRandomButton(_ sender: UIButton) {
        if askTwiceSwitch.isOn && alreadyUsedIndexies.count == currentGroup.students.count {
            alreadyUsedIndexies = []
        }
        
        if currentGroup.students.count == alreadyUsedIndexies.count {
            chosenStudent.isEnabled = false
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
        var string = namesOfStudentsText.text
        if let range = string?.range(of: name) {
            string?.insert(contentsOf: " ✅", at: range.upperBound)
            namesOfStudentsText.text = string
        }
    }
    
    @objc private func showGroupTaskButton(_ sender: UIButton) {
        lastText = namesOfStudentsText.text
        namesOfStudentsText.isUserInteractionEnabled = true
        studentInfoButton.isUserInteractionEnabled = false
        restartButton.isUserInteractionEnabled = false
        chosenStudent.isUserInteractionEnabled = false
        if currentGroup.groupTask == nil {
            namesOfStudentsText.text = "Enter tasks for this group:"
        } else {
            namesOfStudentsText.text = currentGroup.groupTask
        }
        groupTaskButton.setImage(UIImage(systemName: "opticaldisc") ?? UIImage(), for: .normal)
        groupTaskButton.removeTarget(self, action: #selector(Self.showGroupTaskButton), for: .touchUpInside)
        groupTaskButton.addTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
    }
    
    @objc private func saveGroupTask(_ sender: UIButton) {
        currentGroup.groupTask = namesOfStudentsText.text
        namesOfStudentsText.isUserInteractionEnabled = false
        studentInfoButton.isUserInteractionEnabled = true
        restartButton.isUserInteractionEnabled = true
        chosenStudent.isUserInteractionEnabled = true
        groupTaskButton.setImage(UIImage(systemName: "book") ?? UIImage(), for: .normal)
        groupTaskButton.removeTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
        groupTaskButton.addTarget(self, action: #selector(Self.showGroupTaskButton), for: .touchUpInside)

        namesOfStudentsText.text = lastText
    }
    
    @objc private func didTapChooseGroup(_ sender: UIButton) {
        // show view with all grops names
    }
    
    @objc private func showStudentInfo(_ sender: UIButton) {
        if  currentStudentIndex != nil {
            lastText = namesOfStudentsText.text
            namesOfStudentsText.isUserInteractionEnabled = true
            studentInfoButton.isUserInteractionEnabled = true
            restartButton.isUserInteractionEnabled = false
            groupTaskButton.isUserInteractionEnabled = false
            chosenStudent.isUserInteractionEnabled = false
            guard let currentStudentIndex = currentStudentIndex else { return }
            namesOfStudentsText.text = currentGroup.students[currentStudentIndex].marks ?? currentGroup.students[currentStudentIndex].name + " info: "
            studentInfoButton.setImage(UIImage(systemName: "opticaldisc") ?? UIImage(), for: .normal)
            studentInfoButton.removeTarget(self, action: #selector(Self.showStudentInfo), for: .touchUpInside)
            studentInfoButton.addTarget(self, action: #selector(Self.saveStudentInfo), for: .touchUpInside)
        }
    }
    
    @objc private func saveStudentInfo(_ sender: UIButton) {
        guard let currentStudentIndex = currentStudentIndex else { return }
        currentGroup.students[currentStudentIndex].marks = namesOfStudentsText.text
        namesOfStudentsText.isUserInteractionEnabled = false
        studentInfoButton.isUserInteractionEnabled = true
        restartButton.isUserInteractionEnabled = true
        groupTaskButton.isUserInteractionEnabled = true
        chosenStudent.isUserInteractionEnabled = true
        namesOfStudentsText.text = lastText
        studentInfoButton.setImage(UIImage(systemName: "person") ?? UIImage(), for: .normal)
        studentInfoButton.removeTarget(self, action: #selector(Self.saveGroupTask), for: .touchUpInside)
        studentInfoButton.addTarget(self, action: #selector(Self.showStudentInfo), for: .touchUpInside)
    }
    
    @objc private func restartButtonTapped(_ sender: UIButton) {
        alreadyUsedIndexies = []
        chosenStudent.isEnabled = true
        chosenStudent.setTitle("Click to chose student", for: .normal)
        showStudents(from: sortItems(currentGroup))
    }
}

