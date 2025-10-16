BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('771054c6-b161-41ba-b0a1-54393d0da366', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a09cbf8f-81be-421c-b88f-5852c5eea7d3', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4916f712-8b4d-422e-9fd5-e255a3cc940f', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('334828aa-016e-4f0a-af2f-956c53462796', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cac9d523-2b8d-4244-8be7-725fc326820e', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('703ecf1d-72ac-4579-892f-5660918a1c2f', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8bfbf1db-a2b2-416e-a9da-fbdc0f987b65', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4b947a09-2ce4-4d18-8ce6-4407370e39a0', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('450e63c8-0ae5-4e58-8667-4ddad6e10981', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('313cf686-92cd-4a5f-af16-6b225cd8ebc6', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6681fca-a877-44b0-ba33-e0a1eacf978a', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('efb10951-a4f7-49b9-8136-9d89446f45c0', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f93e0fc-5051-4187-81c1-751942668235', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('58d93f0f-f4fa-4103-ad74-345e8c449871', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a84c38b4-a5bd-4abe-ae42-9cea0ac022b5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5bc4d446-093b-4c5d-a896-765728eadaaa', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9d1dd3f6-a448-4da6-910f-e192c876ed43', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2b07442-2ffe-4d34-abb1-c620b139c286', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('035b9cf7-76cb-4e9e-86ad-868e8a9d18b0', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68da8658-e998-4102-bd51-79f0f48193a2', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('15b349da-15de-4d57-bb1c-a50d5dd307bd', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56c36e22-a360-4e4c-b8d9-3341da355bd9', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b96b60b-27a6-41ce-9722-cbb14d6c0a24', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8307cbbf-bd7b-4ec5-83f5-0717edaf27ae', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8d383a7-8eda-4cd5-836c-9303065af744', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f801e267-7fd0-4565-b277-25c401f9b825', '776c7c4f-2c66-49a6-8ec5-a80cb2103942', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a62f907-da28-41f3-93d3-0165dc08eda2', '776c7c4f-2c66-49a6-8ec5-a80cb2103942', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('88fcdedb-1257-4eb0-963f-82499c052dfc', '776c7c4f-2c66-49a6-8ec5-a80cb2103942', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79ed18ac-bda1-48cf-b2e0-89e9c89eafb1', '4172c3fd-fc34-41cc-8f4e-ea2b07c46d50', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ebb82ce5-af8c-409f-a63b-b31d1d3c8361', '4172c3fd-fc34-41cc-8f4e-ea2b07c46d50', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a66ba5e-4824-4a94-a9c4-1be0992752ed', '4172c3fd-fc34-41cc-8f4e-ea2b07c46d50', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('11d7a0fc-c0b1-4669-afc8-350bb5e2e9a3', '4b7a01b2-4a09-47da-89f9-02ee91d8ea99', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81a511d7-f0fb-49ad-a3f4-63e898be7966', '4b7a01b2-4a09-47da-89f9-02ee91d8ea99', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae4bc55e-c43e-4d0a-a370-f69fe9b32312', '4b7a01b2-4a09-47da-89f9-02ee91d8ea99', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f433437-4750-4903-bf18-073fdf59c43e', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8f035cb-1c91-4052-bc46-da211bce7d09', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('237d6540-8d28-4254-835d-2a7870996f70', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1d994288-ae2c-4c8f-aaee-7cee44b20397', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c9c93ebd-c57e-4578-a97d-d0742316ad57', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('704eb8e9-f3df-4cf3-a670-47f2d72cbf70', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('397575ec-983e-4515-87cf-d6d0629b4d8c', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c9fbb1e5-d47c-4ba6-a71a-378088f71fba', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6145162d-d505-4dfb-868e-909cdb995498', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca4d6e81-b996-46d7-a8af-b96d0dd9c069', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('54ba7aa8-c18d-43e9-9ca6-b467e4d1b98b', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21f497a8-efdc-4094-831c-b481ab720ef4', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dcc29faf-54b1-4d27-9197-6e8dfa465760', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbad54bd-ece5-4b0e-8279-28d3b2e48259', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('775d6805-0f37-43a9-b6f5-adf39a6ac304', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ebe90062-8133-482e-9ab3-33c6c05c6c2a', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f2f9ac64-484f-4959-8034-2ba039c83b84', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('342743a6-4aa6-4f58-8ebe-8e184bbe3d1c', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5d9c3b30-3f02-40e9-ad82-c4b06b86aa05', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d45782c-b3dc-4874-bffe-8516b36be1fe', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3ef05f65-4c56-41d4-8e34-7925f0e0f426', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16c7e456-469c-4940-aba8-c80554d2a236', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e1d92a27-bb86-442a-a7da-96f177fd3179', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c35c4dd-5444-42a6-a897-bd62c5fc37b7', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5461d1d-014c-47f8-915c-06ece20b0f95', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3411a41d-2451-4a79-bf16-7706b63e82ff', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a1c311c-7d23-4fec-b2db-96ddb8568f35', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('57af00c5-e24a-45e9-bfae-e9d7a6afa690', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc5b4ce3-ba03-4fa7-ae4b-a5525193cb93', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c7447b8-ddaf-45fa-8b20-a81f9ca8730e', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a6f0f39-75b7-4ff2-a888-337e3eaec72f', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8a994afb-a0cc-4157-afc6-afd35b2ea4ac', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bad3bbad-b0dc-403c-850d-f48f31f3da28', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ffd1801-08f6-431c-878f-cdcfbf4602e6', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7b25c203-2ce7-4e09-9f6c-a5236ddb0561', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b4146f30-e394-4583-adac-317aa074e7f7', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6b63e762-3004-402e-be8d-d1b420f6ef3b', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f0f089d-6ef7-4b90-8d0d-1e93cc89a01e', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8fe590f-de59-4356-8516-7504d33cc6c6', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31f4747a-3f89-4c95-86c8-d9c320c455ce', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74bb16a4-e2e6-4172-ad53-0943b772a4da', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29bff6f8-d8cd-4f84-a747-1ff3fa8f5d17', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f0eb425-9227-48d3-b55e-e8405858f103', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56881a62-c48e-4591-93eb-5a2ef3cca07c', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d06de0cd-ea7a-475b-9207-97c5a6b01018', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f7759c85-9df6-4e33-84dd-c07814be7948', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f5d0fcd1-6368-439a-96d5-dc23b7038357', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7698c220-7dd7-4434-b8b7-8a816d91477b', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ddb828a3-0d98-4e18-a1ef-65eed55576f8', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a9d637f-4196-4713-9b53-ab80641ffa22', '1863f475-213f-49be-881b-16fee75381ae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('acacaa57-51b7-4577-bec5-40451b96b7cf', '12907fa7-4117-4cc2-adad-d3e45e87a5da', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6718e4d-d181-47ee-981d-f2ce899d7922', '12907fa7-4117-4cc2-adad-d3e45e87a5da', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad917478-cfc6-468b-82d7-19aeda77c4d4', '12907fa7-4117-4cc2-adad-d3e45e87a5da', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('38ea1a7f-b15e-4753-837c-0e0d4d81c76f', '83f1875e-b8bf-4a98-b11e-37a2bdb38f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31cddb52-33d9-432a-b5d5-f6846203e3ed', '83f1875e-b8bf-4a98-b11e-37a2bdb38f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('77413a4b-936d-4153-a430-dd0dd324f481', '83f1875e-b8bf-4a98-b11e-37a2bdb38f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('419a4a14-2b1a-49ff-91e9-d0efb0f85a68', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a09bc936-bf90-4efe-a7b4-a1a1cb334eb1', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21ac97bb-8dcf-43cf-9807-aee0c22de10c', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b52c4e6-48fc-4957-8200-bc5bad267e07', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa8ea6e0-525b-4c15-9c8a-b339ac2d8c54', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e208091b-3f7b-4925-926a-d9f789e744f4', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb63ad6c-569a-4e68-91d5-6b5950e85dd3', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0f8b15d-942e-4dcb-8502-08d652b5a3cf', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3c05db2a-b8bc-47c7-9729-514b02fe0ecf', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae0cdbea-eb30-4ea6-bad0-0bac6a61ff77', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ff4162d8-34d7-42c7-893e-060be3f59952', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37970c5b-7bf4-48a9-a6d1-d716affb4d1b', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5a30d82-aa05-4ba5-93dd-39e54375bc97', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83064d37-a26c-48c0-a9bc-31ef29cb77dc', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b92644d1-5307-4f48-8e5a-7d9cb6d49473', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f171621-cf4d-43aa-a651-57e9ed103274', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e5561ce-661c-45ac-80b0-f3152f44f756', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1f54cfc-fd3e-4de4-94e1-5505b6e74263', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('054b3f1e-618b-414e-9dc6-f9828af137cf', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cdaeb06a-c53d-4f4c-a80c-63d4c17788f6', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc03dda3-bfb9-4137-88f3-60fb8490e5db', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b22a5e4-f2b8-4407-bc0a-6f90f7dd6f6c', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d01451e-9829-437c-a119-a9908137eab3', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('661aafb5-1ca7-485e-8e05-f6f4efcddaf4', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c08b4f47-6796-4c50-be17-b6fa49dc694a', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a765aa88-a741-4f08-aa1b-b5b8dbcac35f', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dcd0f1fa-3896-49b8-9315-342e21cc7fb1', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d3c7e583-d6fd-4767-97f4-e72efdb7e483', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('322b853d-ce8c-4b15-b1f5-fb35b865044c', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('972632b6-ace2-4094-ad20-6ad5ed3157f9', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7ff95762-ca51-46e7-9900-06f64d88c067', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc7e054d-1e45-488f-a8a4-099112442109', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a5cb99b-a84f-4fa3-8fe4-84e704985034', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4198b70f-20a0-430c-a7c5-cb458a82b281', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('61c78d8b-0271-4ecc-a03f-0cf9d8b30047', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('afbf01f6-b594-4ee2-ab0c-c1b34ba9bf54', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('39fd9f0a-2630-40e0-b5f8-b5585cb08018', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64cb180b-e328-4e3f-9ff9-c57081e47805', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7a7749f-b5f7-4cbf-92f4-6b5b328da079', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f120cd77-599c-4996-a942-ed979fe87643', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2e86a2b-19de-433e-9606-a1e1640e6c6b', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ff07a28-9fcd-4fc2-95f6-9f252c3c132f', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55087aea-2038-4229-93ed-1091b4ae540a', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('418799c3-d3ca-4820-9b34-1476ff9f0127', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d1c4523f-a9f9-437c-b2c2-fce31baaf705', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51e7da50-29a0-461e-bee8-0ba7ce33040c', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82973a1a-9200-4eef-a4b9-324267ffafc2', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5425f56-01ab-41ca-861d-5adf37e1184f', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9049f797-acb7-4c23-9d8f-caf0045f7f0e', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0d2daf97-d3d7-4cb4-af3c-e98a052cf81e', 'a1a3dbb8-f0c4-42ca-8d4e-0e9bd36337e2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2569464f-23ea-4085-9441-fd0c64ed88aa', '99f0c733-69c6-412a-a8a5-695731fad36c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('97ccfcfa-6120-49dd-9774-b8e444a75991', '99f0c733-69c6-412a-a8a5-695731fad36c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8481289-2138-4379-8057-f3afba1ab0b6', '99f0c733-69c6-412a-a8a5-695731fad36c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72c31fb2-f075-4848-bd06-22e053ea8b55', '92f0c4bf-5d6c-4569-b5be-93a77c63f74e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6fd8cb9e-e6b2-4246-aaf8-1c2d0c7e8a5e', '92f0c4bf-5d6c-4569-b5be-93a77c63f74e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b6dfaec-9294-48e7-af61-101d83d2bf0e', '92f0c4bf-5d6c-4569-b5be-93a77c63f74e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('03414f7d-95f1-4e50-9ea0-c45439045dfc', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2820103b-a2a6-4687-823b-0894838252b2', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5d64bc34-3c44-4d6e-a740-4f329fd692e9', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48f399d2-4b13-4b0a-a967-c95b6569b5dd', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

COMMIT;