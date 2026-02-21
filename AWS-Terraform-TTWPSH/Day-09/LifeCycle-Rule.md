# Terraform LifeCycle Rule
- Are `meta arguments` used within a reaources block to modify how terraform manages reource creation, updates, and destruction.
- Imporves security, Accidental deletion or accidental modification resources.

### ignore_changes
### Create_before_destroy
### prevent_destroy
- Avoid accidental deletion
### replace_triggered_by
- Any changes to the SG rules delete the existing ec2 instance and provision new one.
### pre and post condition
- Pre condition weather an aws resources is allowed to create in the region
- post condition is the resources created successfully
