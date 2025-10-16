BEGIN;
-- ============================================================================
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5aa652fb-ed6d-475c-bd5d-6c9cd2172d42', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2004', 'other', 'Install S/N: 78 NY 1422 G,1 & 2nd') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc66b31a-9ff0-4edc-b8b3-b500356049cc', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2003', 'other', 'Install S/N: 78 NY 1429') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('255dfe40-4faa-4752-9250-1e562fb232de', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2003', 'other', 'Install S/N: 78 NY 1419 1,2,3,4,5,6 & 7') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('db0a0206-1ed2-4ba1-a64f-22dcef608911', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2003', 'other', 'Install S/N: 78 NY 1420 2,3,4 & 5') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83ae41fd-a904-43db-a245-096acf346dbd', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2003', 'other', 'Install S/N: 78 NY 1423 2,3,4,5,6 & 7') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63a1dd39-05d2-4820-829d-523d6df31f85', '428019f8-44a7-43af-9997-c7ae02f96f4b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2003', 'other', 'Install S/N: 78 NY 1424 1,2,3,4,5,6 & 7') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d89214cf-99a1-4219-b13e-a3fc7a6394b3', '92faa954-d6a3-48fa-9956-c99883d99196', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8d306891-a215-4c15-8713-e483fdbd3e00', '92faa954-d6a3-48fa-9956-c99883d99196', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.00', 'other', 'We offer to send a specialist technical engineer to investigate lifts faults. £500.00 £500.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6652f31-d83e-4ba8-b814-e1c6253d4cca', '92faa954-d6a3-48fa-9956-c99883d99196', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc3157e6-9703-444d-a02f-996ac41e9cc7', '9ebd9aa4-7216-48b0-bf32-e34f8ffd3534', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('903ad368-4c86-42ac-86ee-c00c1378e22d', '9ebd9aa4-7216-48b0-bf32-e34f8ffd3534', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e36b8185-81c4-433c-a6eb-ab903e885f89', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '35', 'other', 'Coolant-HAVERLINE Premix 40-60 5.31 185.85') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc1581ce-6ccf-4df8-8af7-078573988bd7', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Hose Blue Silicone Heater Hose 20.00 40.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('530685f6-35e9-4035-a69e-0712b8e5cb94', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Clip Jubilee Clip 3.50 14.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3500214-b508-49fd-ae58-8be0b14e5ede', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Flushing Agent Speed Flush 11.45 11.45') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ffa8e21-0a8c-451b-8ad4-5ed6ed9ef589', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Consumables, Sortbents & Cleaning Agents 52.31 52.31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72ffa126-fcc7-4d1a-a765-e0278bec2ade', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Environmental Disposal Cost 16.00 16.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81ca67d8-4a2c-422c-9aa8-d2a34abdf5bc', 'f379b9d3-146d-4c66-abd4-5a6e43d641fd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Labour - Special visit - NWH 560.00 560.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a733410a-a26b-4491-9c5e-0f87a9fc7f7e', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'A request has been made of Grainger for confirmation that the company does not') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae59bd11-e625-4c03-8458-d4baab6c0b02', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '30', 'other', 'November 2018 - completion of all background work to enable an Agreement in') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f97ddd95-8ab9-4a80-9563-ff45957e7956', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '18', 'other', 'December 2018 - resolution of outstanding issues with Grainger.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e03ed13-faea-4b7d-ac76-9808a11846ba', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '21', 'other', 'December 2018 - issue Notice of Meeting of Members to be held on 18 January') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('15c4eaeb-289e-4288-97eb-8fef15982d4c', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '18', 'other', 'January 2019 - meeting of members of Grainger (leaseholders) to explain events') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ff407c85-6127-4d73-b2a7-b55e980f2ec9', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '31', 'other', 'January 2019 - AGM to appoint directors of new board to replace existing') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8b675734-69d3-46c1-a669-9cefe35b87e3', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '26', 'other', 'September 2018 at 11 :40:48.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('db77886e-c043-4f9c-bf27-7a2f28401486', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11111111', 'other', 'Title number NGL952059') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('371b96b2-4856-4ca8-84c6-5cffd1322559', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11111111', 'other', 'Title number NGL952059') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('432c1bdf-174f-498c-9f94-a59a6e12465a', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11111111', 'other', 'Title number NGL952059') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('54a6460c-379e-4651-8c60-091799cd8466', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1111', 'other', 'Title number NGL952059') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('40a71f8a-45c5-4462-a264-6526d550b1f6', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'OCT 2018 at 12:23:20.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c4fed612-f78d-4114-ae34-e540e9bbc2c4', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Property description: Parking Space 47, 29 Gillingham Street, London') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe6e32e7-d410-4eaa-ab7d-536e1f4c5533', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Property description: Parking Space 1, 29 Gillingham Street, London') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fd6e49b5-712b-456d-9baa-32350968006d', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'other', 'To acquire and hold the freehold or leasehold interest in the property or properties known as') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33589b82-23f2-46d3-9463-5a6dc2b0311c', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'other', 'To acquire and deal with and take options over any property, real or personal, including the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('87ae9f8c-b98f-4d9f-85f0-05704894fdab', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'rent', 'To collect all rents, charges and other income and to pay any rates, taxes, charges, duties, levies,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0938ec0e-3610-44c7-b370-880f000d72d8', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.4', 'repair', 'To provide services of every description in relation to the Property and to maintain, repair,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('798a4a9b-cb11-4a18-beff-f468405e4f17', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.5', 'insurance', 'To insure the Property and any other property of the Company or in which it has an interest') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80397270-eb76-4de3-a829-fa9069e24d5b', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.6', 'repair', 'To establish and maintain capital reserves, management funds and any form of sinking fund in') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99d40f4f-3fb7-425a-8012-929d451ffd0c', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.7', 'other', 'To carry on any other trade or business whatever which can in the opinion of the Board of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('769d606f-f8f2-4003-a35e-aad5986c9329', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.8', 'other', 'To apply for, register, purchase, or by other means acquire and protect, prolong and renew,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8602a391-aefb-479c-9ae6-7e3f7eb824c3', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.9', 'other', 'To acquire or undertake the whole or any part of the business, goodwill, and assets of any') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80832da9-0cab-4bf8-85b9-9d4b85d0d8cc', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.10', 'other', 'To invest and deal with the moneys of the Company not immediately required in such manner') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9129ec71-f678-4587-a165-bc21934a83d4', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.11', 'other', 'To lend and advance money or give credit on any terms and with or without security to any') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6eb32d78-b3b8-4912-9f31-591159285a1f', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.12', 'rent', 'To borrow and raise money in any manner and to secure the repayment of any money') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41abf876-9fc6-43dc-a1e3-b5ec6c1fc78b', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.13', 'other', 'To draw, make, accept, endorse, discount, negotiate, execute and issue cheques, bills of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5cf501b3-e6dc-47a3-99d3-d428ef66376d', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'W:\BJO\Word\Mem & Arts\Grainger Pimlico Management Company Limited.doc') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7b28a980-3af6-4ab5-948f-c844eb95c317', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.15', 'other', 'To enter into any arrangements with any government or authority (supreme, municipal, local') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0364e2d6-fcef-4816-bc49-7dadffa80198', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.16', 'other', 'To subscribe for, take, purchase, or otherwise acquire, hold, sell, deal with and dispose of,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1393ec69-9e42-4dfc-b837-f8acdb476dd7', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.18', 'other', 'To promote any other company for the purpose of acquiring the whole or part of the business') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19b6a37c-9be6-4957-9fd1-30b06e2caa0c', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.19', 'other', 'To sell or otherwise dispose of the whole of any part of the business or property of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dc136c03-fd6b-4fd8-b40a-82a33a5e87fd', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.20', 'other', 'To act as agents or brokers and as trustees for any person, firm or company, and to undertake') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02ac34f7-8400-406e-b151-6f6c90278d9e', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.21', 'other', 'To remunerate any person, firm or company rendering services to the Company either by cash') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2af4a0a8-d32a-46f4-8c59-fdaf8ed48815', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.22', 'other', 'To pay all or any expenses incurred in connection with the promotion, formation and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('23687244-e732-4172-921b-5ffe8195296b', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.23', 'other', 'To support and subscribe to any charitable or public object and to support and subscribe to') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e36dfd2e-e46d-4916-bc24-8873a40689f0', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'W:\BJO\Word\Mem & Arts\Grainger Pimlico Management Company Limited.doc') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cab7f2be-3974-41df-a7ee-795200cc56be', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.24', 'other', 'To procure the Company to be registered or recognised in any part of the world.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('67046879-c0dc-451a-861e-dcba465ae6c6', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.28', 'use', 'None of the sub-clauses of this Clause and none of the objects therein specified shall be') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f7cb7e13-5059-4d61-a8d6-f4699573e4bf', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.29', 'use', 'The word "Company" in this Clause, except where used in reference to the Company, shall be') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2b787ee8-627d-447d-8264-a83b593653fc', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.30', 'use', 'In this Clause the expression "the Act" means the Companies Act 1985, but so that any') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd73e4a2-e4e7-4b6c-b4bd-291fe48e2278', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'W:\BJO\Word\Mem & Arts\Grainger Pimlico Management Company Limited.doc') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16ca61cb-c94b-49e2-a1b8-fd4ae6bd3ab3', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'W:\BJO\Word\Mem & Arts\Grainger Pimlico Management Company Limited.doc') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('785c1ad2-151d-4a4d-8220-51cee63e2123', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'other', 'The regulations contained in Table A shall apply to the Company except in so far as they are') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec8f78c9-9971-4ae0-8608-ba8557b6dbcd', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'other', 'Regulations 2 to 35 inclusive, 54, 55, 57, 59, 102 to 108 inclusive, 110, I 14, I 16 and 117 of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e98f1d9-9b71-4fc2-a174-a4364c39b9fa', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'W:\BJO\Word\Mem & ArtsiGrainger Pimlico Management Company Limited.doc') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a557bfbc-04c3-4e64-8387-f78951192bf8', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'No person shall be admitted as a member of the Company unless he is a dwellingholder.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ff86aefe-b25c-4338-9b28-d36bc22ff3ba', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Every person who wishes to become a member shall deliver to the Company an application') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3aaf02cc-b741-41da-87cb-16c76b527cad', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.4', 'other', 'A member shall not be entitled to withdraw from the Company while he is a dwellingholder.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d358f7d7-4711-4ac0-9720-e90ef0a66707', '71cbbd82-f1ff-4ff6-8ea7-432f3cfb9f45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5', 'other', 'If any member of the Company parts with any interest in the dwelling or dwellings held by') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('852b555e-6fc9-477d-8b73-9e06f601f74f', '75807128-5859-462a-98f0-d72074417de2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2357a21-8088-4027-9f24-166f49678a12', '75807128-5859-462a-98f0-d72074417de2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5820e0a-2367-4518-a836-f0f700e035a3', 'a2b9f1ec-6373-4d78-b6e0-fc70b398cdec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52c2dbbc-66be-4b3b-84b3-5c6c5b197966', 'a2b9f1ec-6373-4d78-b6e0-fc70b398cdec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e94c365-621c-4ef0-8a6d-f9cdbd85d47e', '59f86648-0709-49f0-aad7-5f04145d110f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dc1515b8-034a-483b-b0a0-c9a00960dde4', '59f86648-0709-49f0-aad7-5f04145d110f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7aba29a1-1e96-4321-b776-94426d040f36', '49b5469e-c796-461b-abe7-a6922dc44456', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '29', 'other', 'Gillingham Sreet London SW1V 1HT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56a26166-b26e-4fee-8213-6c1357b51e83', 'ee8f2df2-d2b6-473f-82e6-32db53c3de4f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8324', 'other', 'Scott Smith Pimlico Place Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e936cdea-f5d4-4ec8-ab89-5d941e0d1b92', 'ee8f2df2-d2b6-473f-82e6-32db53c3de4f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'September 2023 Unit P, OYO Business Units Mark Ingram') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e6670be-c5b7-4de3-9bdd-380d6408fb3c', 'ee8f2df2-d2b6-473f-82e6-32db53c3de4f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'October 2023 Wallingford mark.r.ingram@gmail.com') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98b00b5a-b289-4f62-bee8-1aca63dee568', 'fee82685-caed-4b14-9e79-bd31c377ca5d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '16', 'other', 'Lower Belgrave Street, London') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2b710e99-3452-4284-adc6-0c35988eaa3b', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('35d475f0-9503-48a3-bfc9-e9a6463187e2', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a78b4969-029c-423d-8f7e-bb9ae67206b9', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a38c9485-8e1e-482d-93e6-e86bfd8515f4', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c904609-08c2-4bc8-b207-30836e385ca1', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8a0bc933-c7c9-40d7-ba8d-e50d4240c817', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3cb6ef7-798c-4336-89e7-3406c2057c93', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7e4adba-1604-480d-b03f-5de9c2ef6aed', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1e8bb40f-eddb-4e61-9f65-366f75b8dd19', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f2cacbd5-2aa7-4207-aef8-764f714d2244', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f83aef0-4a4c-4420-95c6-d131bca3e200', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('145ae461-a905-4a7d-a068-2808d5ffe387', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f57fab24-9f29-4003-a52d-ae70fa861a8c', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d2a7d31-77f5-4abe-ae71-e65128c10546', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('458ef895-eced-481d-9a5b-7fe919f074ac', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc2737a7-ab83-40b6-addb-03c27ee9290d', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7b6d52c6-d9c3-47ce-9248-d0b2f75050e8', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f9e22e3-0fb9-4251-81b4-77df8e09738e', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f7eef817-99eb-48a7-91e9-2bc8701342cd', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('71c1cf99-8367-4671-a90e-2d2dbbd68065', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05e0ab4e-da3f-4137-b009-56f39fbc8065', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('747db476-cf62-4860-8fd6-8b5b3ab48fcc', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ded82667-6b91-4a19-9b12-47b148e681a2', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c7c7ad9-26a8-49a6-bbc6-4c616eea6330', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ebbc04d-4f37-4fc5-ba03-7af3fa8e909a', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a9f66d18-9a30-4a50-9d8f-ad862e5d01c6', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1d9814fd-aaf4-4cd0-a66c-b421db8ec15f', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99394232-d5f5-4966-aaee-ddc49df91a39', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('436d829d-9807-494d-9688-bd252f146a0a', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('abac6436-6d8a-4a8f-8c38-4430fcb4a918', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f4b2f36-bafd-42d3-8920-eac9457eb285', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7927bbda-64ba-4ea9-b82b-102810c83e65', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44ec3886-b526-4d28-8ba7-3e0465ff6892', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d91e0583-d591-4847-a59a-63dd49e5ec0a', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0f641104-a630-4619-a95a-2f45a24bc005', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68757af4-9578-4915-9502-561a0a1dc49d', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3d41c12-9fce-4e51-b77e-e4657caaa7ac', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b26a7788-536a-47f7-9e2c-af50f3afe89a', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eea9630c-ad90-4cb8-b04a-6cf6da9bacbb', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d7cafa9-a202-4435-9473-7f91f958e8ef', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a19a107-6e60-4146-bc16-63bda32c3522', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('529ddb2e-34f7-4d33-bb3a-2d72c6add1ba', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4dfa501c-15dd-47d2-99c2-4fcad40559eb', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a48cb0ba-26ab-4629-9a5c-8163ff9e5642', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e904945-26c2-4beb-8eee-0fbcbb0540a6', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb8e959c-fc03-479e-a2df-1fbadca5c01f', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aeb1bf3c-8ee9-4f7d-85cd-06a115750c25', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7363937d-96cc-40f3-8516-73dabf6c8247', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c72e0b5e-78d0-48dc-813f-33e90f333ade', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d555c68-ad47-411c-847f-cda811677108', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1d464f1-88b8-45d0-9475-aa489a57cb3b', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f001392-04af-423c-8e38-5823287a5eaa', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b133b268-affd-442c-8421-526ecbf0c861', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9696ee6-41c7-43c2-8c91-ae30420b2ab3', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc2c9d74-0bd6-41e3-90c3-a37c05c8b3df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bcabb5d-7451-4d4b-84f7-ebcac59af0ce', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d369c6d-b361-421c-94fe-36fb1f6039e1', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f860d2f4-9f78-45ba-af9b-fe8a6d112f23', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2fd4733-ecb7-4e0e-922a-7a18d1d001c3', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a6866689-3c6c-414c-bcfd-9272f7c59fd2', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3fd2db86-68c6-4664-a765-994e86776492', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('35e5c520-a14c-476f-8c3e-6ad3ddcfa160', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45bdbd8e-5270-4ab4-a716-ba86c102c061', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e46631b9-1958-4101-88b1-461042736c4d', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b73bf17d-1380-4e12-a1d4-c234e9be64f9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19768c2f-f7f3-4c86-8ccb-737aec84fe1d', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c0b7d2e-a325-4dda-bca3-719ddae63ef5', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a9d66719-1607-4384-ad27-d1d0eb8b2b1b', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c1fb7a9-927c-4e94-9db7-22cdd598855c', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9daaf1c5-ccae-48bc-96a1-f2fc5b31f2ae', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('055d5775-3ec5-462b-be01-256ad9aa06ac', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('adc4105f-e92e-4f26-b07e-0b937d47255f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dc400306-dd5f-4131-9bc8-86736e3dca42', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('898faf49-20d4-4f84-b178-44a610b75a77', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('142254fd-a2ea-478f-9d0b-b071bcd2466a', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c9feee3-4f63-4e71-a5d9-cf8b370e2a7f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b297aa4e-4ecb-45c1-af68-9e45d5c14eb4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65041ee9-f17c-4e17-a4bd-8ff7f0175fe9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74b99e10-05cc-4a71-a0f3-e4acb201eecc', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('78b15bc4-8eee-4fd7-91b4-d0b0550cdb37', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd1a4820-5daf-45dd-b5ce-759db4d75e93', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37d96605-78e3-4989-9925-54cd717d49dd', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('50add190-7409-47ba-b142-20c7d3941ad8', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00f38f1d-9aa5-43f8-b8d6-6cd62a43b1df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8cba9d8a-aceb-41f0-b68c-1551a9061dce', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfd241be-3d2d-4c9b-ae4d-932801de3d45', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44578035-b5a4-4f0d-bdb0-069f94ea1732', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa20261b-e427-4490-a7a5-5f82119cae4e', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a6ae9503-241e-4fb1-8604-a2ff2ac085df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0c96fbc-38c2-4d93-be7d-b14d861eab1e', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63b550e3-84f6-4477-81e5-d1fe31bc56a9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9beda427-a677-4d99-ad41-f5cca08eafc2', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9bf665ef-1499-4fc3-b853-3fd4a5d58f70', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86531482-b9bb-4c9d-bf99-d448f874f00f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb42092e-52fb-4324-8a8c-29ec4d1b69d4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95d3831-b9d7-4868-a62d-b124117f98e4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba07d0b2-454e-4c58-ac8b-963b56a39c95', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8f31030-28f2-46b1-a874-76d9eaf367b0', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ce7f678-1aa7-4022-b6b0-73d0b70adec4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cbd134a8-7686-49dd-858e-6dfd19453d60', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e6714ec-2fed-43a5-be5a-7ba00b99cfe7', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('77e9c91e-d6b0-4bf1-9fc9-29bbcb5640b3', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79f28b13-9010-4f08-b465-084d0d62a706', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28d56b08-b2f0-4ef5-a4b3-e5162b033fda', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('625bf9e0-1a93-4350-8415-8cbeb118d0a8', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b4b343f-cee2-4d63-926e-21cc3f754c53', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7976087b-8db0-4279-8312-065eed4ef1ae', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b47f0d0-9ae8-4ac7-bf16-8b8308a4c151', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbfee56d-ef7e-460b-8092-e15efb013feb', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('61eaf9b0-a963-40af-9c75-acc8bedbbfe5', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8bad2151-4535-4989-8387-1233187c9447', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('192c7ec4-0aa0-4d29-b6c6-268adf0bff3c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37f66524-e66f-4963-8782-c512b85062ad', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a013a24-89b7-472d-b32a-4c48ab237578', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b63152fe-9b16-4aa5-9ac9-851e80bee336', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('305d9c08-e1e0-4782-9cfa-dbf19909b9fe', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('58383028-16cb-4117-837e-d9b0bc29475c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8a1c0b2-39cb-47dd-9be0-64b3b963ea37', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ccbeac41-75e1-48f0-953d-7a5d698279b9', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aa813a3-9f06-4e7f-82b4-998484ebd6e1', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9498963b-2d83-4e16-953f-08721577f256', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('20f55e4a-8f4f-40a7-93e5-0fbd2e62419e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6b74162-61f5-4d78-af77-d76603dcaa9a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ee5b617-2b47-4ce9-8013-fa85ae26fa6c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd28ee14-81fe-4a3f-a9f6-83cafc8b8613', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa4264b9-13e0-4592-990c-71215b21fc2d', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33810439-e9f5-485a-8a84-62ff0eaf1d03', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d258499-8f15-4bf9-88de-e7c71ce25ea3', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25bd00d7-83a8-49ae-8a43-fc1227982d50', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('661f2ecf-b554-4a2c-9f11-1f605b855b9b', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b41c82cb-99ee-4e57-a3d3-827887fce651', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe3ecdfb-fcbf-41e0-95dd-ae96c8fb261a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d383537-af2f-45ed-89cc-2d9193801636', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b87450c8-c327-4765-9acc-74f1751f6a52', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b02ea2-3935-47b8-993f-61f8777cbe2f', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('553043a4-0c96-4d2e-9845-52519a49d3d9', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9eb37f84-156c-480f-8e54-f339f45f751e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c15334e-2e6b-407e-9102-a47844dcda2a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7fb4bbc-5d8c-4081-954a-917fd2916e36', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4b3d0286-ee11-4b06-91df-d6e5b991379c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83f63208-ff27-4347-96f1-4d8db0c8507e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('842907c8-7217-47cc-9b20-8245eaa03258', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfbca6ba-bd86-4d9d-838a-f831b8512f83', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7197831b-4024-4924-a28b-354f0c7f6907', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e3c1f83-c62f-4110-ba24-15fc3657e589', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63893f7c-e9fa-4406-9917-1b48f97f1711', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('155f7dcb-57d9-4731-b130-962a01cd393a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fa84514-1abf-4a25-b3f5-f9b76d5c5c3d', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cf14347-67d2-4154-ad9e-4a555f8ff930', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('76cd42dc-a168-479d-ac42-3b9a15edd3a6', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31e43b4d-4f62-40a5-a004-0b6633aa4a6b', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3ea1d21-60ea-4fd9-ab1e-8b3c2fb24767', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6e59cb73-b7c5-4313-91f2-e02f6dbbee80', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ea845b96-4334-4aaf-836b-95e82aea095c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82785b82-888a-4649-ba15-2a1c989997e1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c9dc4b30-5bcb-4f02-b846-5d5d7c09c845', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d98ea4c6-94a5-4fbb-b713-4b60f6ff474f', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab332595-20d2-498f-8f01-9aed9bac049e', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a092e982-88a8-4a5c-85ef-3c2268f954c3', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8600f5c1-2551-42a0-a9a6-77cc1dc221c1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba7fd66a-29e6-4e49-b2c8-9726e934223c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b19bd3c-33ca-47f7-92f7-fb1ad2be3d71', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfbe4ec6-ce4a-413c-92de-e3cd86ac7e37', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b77a919-b980-4e89-9a7d-17eb8f19477f', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56982915-cdea-4096-9477-dfd334ac3237', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9eb31175-2701-4c62-9b88-26958f105ae2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1e4f6ef-a81e-4783-b9e6-85ce103428d4', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa713b2e-b478-4bd8-a078-cf453da3494c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('307b47ce-2e68-47d0-a7a1-ca6bd103de86', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b75d80c2-363c-4d22-9d3a-af106f254dd7', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05619574-587a-42af-b7f3-46cd4be95ca5', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3edc8225-df1b-4c82-a914-400b48eae35a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ff5a7e4-5164-4d48-a093-084b1b64ff49', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f42a2a91-f1b6-4f1e-beb1-6bac526bfeec', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a7a422a-42a2-41a3-a674-4775c9b635a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f48107dd-d31e-47c7-a13c-42da22fa7e17', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49faec40-a177-456e-9a03-6058ff314c86', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6c04aa5-0669-4415-9ea1-7d0eb8c46a89', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('40e15aeb-346b-43a9-8fae-5519a2698fc7', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f2f9efd-2745-44cd-af53-3abe4861c4a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('834cd014-75f0-40d1-baf9-8d66de90e129', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('679e2e82-db66-468e-ba2f-3d9629dba7d9', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e2aad7df-a384-4d95-a542-5dd4aea34533', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8b9916f-5c05-46c2-a918-3c352b1d219a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41f167e6-a70c-4477-94df-7dd5acafcbe3', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2b8b839d-f864-4d32-a4a9-d98498ac598c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c960ba66-9855-4085-9521-70c8c710002d', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aecfb5b2-bf04-4847-957c-c598708488a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b73765f8-e984-4705-99da-31d95b03d4c2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('198cb214-4f94-4eb0-856a-30559ac5fc88', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11493ed-9ce7-43ee-9d1a-251c62093781', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1413d216-5d2a-4454-adab-a7a0a0ea4654', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a357b42c-9bf0-4835-8b8e-3ecde054a8ad', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37de473d-0b37-4bab-a9ad-bb2abdb3f81a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6000cafc-55a3-4414-9415-88cfd7229c26', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83d61d9f-ef16-41f1-8a4a-46e64af5d304', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c005b089-7328-4b54-9bfc-a0c7e53e9d3c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4039438f-e453-4191-92a1-0540623b8f84', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('677ea3fc-4c22-4077-a3b0-55c0c5f6c6e1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89a78cce-4641-423b-833c-bc30e67813ea', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a74bb2dc-e878-4168-8eee-549673c4c6e2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5924501-4eee-42cc-b3b4-0465a393deae', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0aed461-fa97-48ad-825f-2a84e9f5f728', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('203bb33d-f960-4db4-ba95-29890a481a17', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a2991fe-53d5-4535-92e8-bec532af7dfd', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('442075ec-0f8c-4aba-bff6-0c708f6d26e9', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d3602a1-9b0a-419f-aabf-c9839fce3075', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64b46b88-94c4-4910-9541-e20dba5645d3', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents/Tenant’s Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6e5d4e80-2022-454e-88c7-741ffd640eb5', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b9edf4eb-64e1-4df6-b8ec-1ffeda7fa106', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45e2843d-28aa-4784-8d9f-f7554501758d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28424f94-ed9b-487d-8743-53f268a6f871', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the Buildings Insurance Premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5316ab16-3061-4ab7-a5c0-d587070dad4a', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who maintains the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e7ab6d36-885d-4f70-a5b2-01c8ac34d033', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who maintains the Common Parts?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66ae9d98-7f49-41d6-903a-97051f34a7ec', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c2deef91-d79a-432e-9066-dfe48e7df2d9', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed including £ 100.00 + VAT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98734f40-4b87-403c-ba11-263b8ad2f320', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign Required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e3ff768-043b-4fed-8abb-c0a468a54d26', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5cc0b9da-fe03-4a69-963b-6b4c3c2436bf', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2901af2-2487-4885-bbf5-f6658eac3f5f', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7162138d-5577-49a8-9256-f581adff020d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('03efffdb-cfef-4720-9c27-2f1a7f9996f4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96275736-95f4-4558-998c-1b97779ad5da', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a certificate We do not believe this is necessary') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e90a7578-9952-4370-ada2-5b8ac378fab1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable by this Property? £ 300.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e141299-0876-4372-8add-30ce9f9d95c4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1647aaef-a51a-462b-8c0a-ab18a3b34f80', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8516548b-574a-4e99-ad01-d616cbd207ec', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5cc99bbb-752c-4852-a218-c867de6e0cc9', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'repair', 'How many properties contribute toward the maintenance 79') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56ad8db1-7c63-47a2-8e6e-44a553d97375', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for this £ 7,236.43') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af4e3b22-6152-4cd7-95f7-230041751afc', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Are the Service Charges paid up to date for this Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ca73a97-b0e4-43e9-a826-48e7468aad24', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6577dee8-4ee3-4a04-a330-bd598aaefd46', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any Excess Payment anticipated for this property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37dc1bb5-6a42-41b9-bea9-f38b1b015f33', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details: We are unable to confirm at this time.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e45a18a3-99e5-45d6-811a-3e28202c3f8d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47f4a1d1-f17b-4f18-ac8e-8e86ebec66e4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('70e486a8-4d15-4058-b2bd-a15bd04862fc', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44bdac6f-1594-4884-b86d-b67e676dbd5c', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to this Development? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fbb0cfa3-5c30-438e-aab9-8f60c02e65a0', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If yes, confirm the amount collected from lessees £ 295,962.53') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74de32d9-3d33-403f-87e5-77228127443b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8dbf9261-c8e5-41b6-9e64-cd0b12216b4d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33a0df1a-9e7c-4459-bab4-46dd9c4c2bcb', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Common Parts were last Internally Date: 2004') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d002f893-dc8a-4ff8-918b-f7d47dd56841', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are there any section 20 Completed but unpaid?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1226c498-4288-4f20-9212-5a9fdc6dbec1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cd30b79-bf97-41cb-82ca-7f51790de6ef', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('35fad212-e8c4-47ec-be06-d790e97da6d7', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details: It is not expected but we cannot confirm this') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc30954a-c208-4bdf-9dd9-665cbd6148e2', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96c64a90-6c41-4af7-8575-ca72f5dc398e', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63677db5-24d4-482b-9214-b78c41fea3f6', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('17e66563-c3b8-45ce-a57e-6b9d50ee2f07', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1c78134-b8a4-43af-ba35-a3fae747b16d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: 01/04/2020 To: 31/03/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('744d26ac-ac51-4c74-ad35-15d6c6ebe4e1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Confirm that the premium has been paid in full: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60a43b84-e1c6-47e2-9e83-3c18ee99806b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a51f0bc-2f7d-41c4-8b34-27cdae3da64b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.4', 'other', 'Are the interests of Lessees and Mortgagees Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('71fb1934-4142-4858-a5e8-bbea0cba720b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5', 'other', 'Are the Common Parts covered by the policy? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c9f23f8-1610-4bc1-a038-7853769cdc34', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5.2', 'insurance', 'If No to either of the above, has the insurer been made Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d3269ccb-b0fb-41af-b8e0-e9456772d39b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'forfeiture', 'Are there any on-going forfeiture proceedings in relation to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65f10444-44ed-4479-b9a9-1da9660d9109', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('efbb57f0-8a17-4416-ab05-6ce1fe83005f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8b2f9f40-9781-4d5a-8c0e-e2500fd68982', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2285810d-7457-41ad-b642-3ca8b71953f1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3ac02c04-4123-4432-8276-6845d58ca996', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d120dc0-70c6-4c58-a6bf-d8e1e1f9a486', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5128b28f-ae88-40a3-94d7-dae9bf0f7dd1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3de7745-12eb-46a5-9cff-a81521548703', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bba9c6c4-71bf-42df-8fc2-ce2911d5cf9a', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e14cb72-1bda-4128-97cf-63ece7de8b37', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8cfac26-f0ae-40f9-8567-410e2ad6af54', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0dedba2-4c98-4f52-8925-b62b1a50ebbd', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ddef568-0899-4878-a2e5-f2a924941db9', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('354188e0-6f76-4f91-8261-1aded16eff7c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b76544d7-627e-4059-8961-ec35d5a78bfe', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d335c343-59de-440c-9f2d-388ef5f30b1f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab71721d-8325-47f3-a818-80f8ba542a2f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4b8ade42-05a6-4e74-9216-f91e99c3370c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b11343-7de5-4a34-b47b-e85dd5088333', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ae8f6f7-64d8-447e-9f39-dee3be7ebb02', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa8f502b-2eb2-4670-96e1-627224c4b2d5', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c4c48b8-22a8-47b4-a3c9-5b264ed5f844', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7c07119d-ca5d-4f5a-869d-3cb1628f72c1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ac2b821-d879-4c86-a18a-4065dfc77c52', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('edb415ae-071d-4056-b6f1-4abfd79f2f53', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63c37717-4dd6-4387-938e-a6228c528d5c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d25425d1-d5b2-4f98-aa6f-e91e419ced16', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48dad4c6-7f0a-4c9b-9670-c5f9ef80a82c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c593eb2f-4eb4-4866-b31c-95f5a1f88f96', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f25a339b-94da-482c-b83e-85a009ba725b', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('416f65dc-6603-4072-8685-7d78191709c8', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9d1c7c18-a281-4585-a7ac-6db260259a67', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ffa67c7b-26b1-4d6f-a2ff-d64393295417', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('681f7d5d-a327-47dc-8ec8-8e6d6a443711', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('775ddc27-4b07-43b9-ad90-26b4a5d993ee', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d872e576-8099-4ded-84ae-85601f1ff313', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a79ce4d5-6d3a-48c2-872b-18a6c09a9c96', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('121ac246-753a-4793-8263-7ddcbea5642b', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c579686-6e88-4a85-bf3e-8ecd027fa908', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8f32f43-41df-4e15-8515-5598db3d0dee', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('90aa1293-5c50-42f4-80ce-75c2c774b56f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41027b84-cf0d-493f-b6dc-1a5e02c897a7', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('632e4753-2bce-4c73-aace-378c816daa58', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9dd1d56-f027-4d98-af30-0189bbe71228', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b55e54af-95c9-4447-90d1-3ed4608cca8e', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c2eef0af-26c1-4bc3-83f2-fc40ab1fb11f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25867941-7629-4444-9a5e-bf549187ba71', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8dcf34dd-6f5f-4e22-8119-fe681e7fa517', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, provide details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a9d360a-e02d-4ce4-9c82-39adc69a653a', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d31f5d9-b531-4b13-8d41-436813523414', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Has the premium been paid in full? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3adb3acc-8f8a-4550-8d68-fcd44b6fb344', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95be375-8972-4c29-a264-689931595a58', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents/Tenant’s Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('338ee746-bea9-439e-a7d6-16a17f2ae243', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('10481e15-c205-4bee-a376-99fb8d45b7ec', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7ebf9a47-d0a6-4feb-a550-3e9dd09f7fc7', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('057a888b-4847-433f-b52b-82a5da938eba', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the Buildings Insurance Premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37422b5d-a242-4512-87f9-3a9f59049d40', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who maintains the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5b30f933-2334-444a-b522-1a9d178b2ddf', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who maintains the Common Parts?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4811b90b-62c0-4dc4-b26c-a9e5b897e0d6', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02aebd75-6085-41d9-9f12-34d54e9661d7', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed including £ 100.00 + VAT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cd954ce-4e39-49bf-b42f-bb0981be322d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign Required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51dfa28f-0716-4ecc-903d-92033b5bb74d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ac571d00-e39c-4df1-8ba5-211189c80f9b', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb973ff5-dc04-4c0f-ac5c-3e88820f90a3', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d0ac4f04-af4b-4451-999f-e6b2312ce21a', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51b11a4e-2c2c-446d-8e38-afc45ab59eda', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('885a88df-2253-480b-9f00-bda4c05c77cb', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a certificate We do not believe this is necessary') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59d3c871-b961-446a-9b4d-7f28c065a991', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable by this Property? £ 250.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c79145f-3399-40cf-b23b-add8e2fbec25', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4506fc7-8b73-4b79-a901-aa4703059044', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19415f68-5a27-4a3d-b7df-042f7951278c', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('235a3311-7d81-4627-884a-09ba6ec7abd8', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'repair', 'How many properties contribute toward the maintenance 79') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cdded949-2478-4da2-baea-1a94814dbf1e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for this £ 3,766.12') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8dbedae-594c-4131-adbb-767153b7ac31', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Are the Service Charges paid up to date for this Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('805c078c-e679-4845-9ac4-4f1cba5c833f', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c39a6b97-3a74-4343-bd40-1fa15bb44717', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any Excess Payment anticipated for this property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ff2910b-970a-41ec-975e-020f08c5262d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details: We are unable to confirm at this time.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('baf3af87-a364-4e11-828f-aac0d456a363', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8fc3b698-af19-40ed-aad6-27c5f5416ce6', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('323fd4b3-a06f-4faa-90cc-4ce19855c93b', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('39b6f290-ce6e-4974-b14b-cb08b2835750', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to this Development? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('398198ca-95c3-44a1-bdb5-f8ed7abc5e7f', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If yes, confirm the amount collected from lessees £ 295,962.53') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc6b65f7-1a20-4d57-99f6-01a5f7efda5e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0278825-6a74-42b4-ac24-7bdb0ff0372d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f56a2379-a1f5-4676-9e62-29e7dad0167c', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Common Parts were last Internally Date: 2004') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad98cbab-e25f-42c3-8bd2-a20a85247b87', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are there any section 20 Completed but unpaid?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5771c4cd-573a-4d22-99e8-302a6d84bf1e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c29c3b9-1556-4b1d-a4e8-ede9b5697c67', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1cbc4422-6d13-464b-a906-fb5332149193', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details: It is not expected but we cannot confirm this') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6115f9b8-96a3-41e6-8eb6-7d3f331074d8', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3545f8a3-82e1-4814-84c8-ff1eb5a5f1ad', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('492076f1-7f3e-4a50-8018-5171400632c9', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e8eb2de-0a89-464e-8bba-28e3de50414d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('190a0c82-430a-49da-b76c-4429ad3bb4f2', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: 01/04/2020 To: 31/03/2021') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('833843dc-9f31-4c20-b6dd-9cded5c2d12d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Confirm that the premium has been paid in full: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21e99e86-3b4d-4084-aa17-576ce42a9400', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('144ed173-3f6f-4fd4-ab5b-5f64fbe51208', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.4', 'other', 'Are the interests of Lessees and Mortgagees Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('afb71f76-9509-4c2b-8c5f-34f1781e3df1', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5', 'other', 'Are the Common Parts covered by the policy? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49e02132-94ba-484a-a766-d3b2e36dd6e3', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5.2', 'insurance', 'If No to either of the above, has the insurer been made Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d46a54c-1764-4fa1-b24f-1c209f2cee15', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'forfeiture', 'Are there any on-going forfeiture proceedings in relation to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9abf74b0-4df4-4a29-abac-35bd3564a095', '05f32b17-81db-4bb4-b26d-d6e6ba47b23e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aa19752-8169-4ec4-a49b-bd56cff3e91d', '05f32b17-81db-4bb4-b26d-d6e6ba47b23e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26aff5ea-c049-42c9-8267-e8ec9508c41b', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('571200db-cedd-4608-b2bb-b36422fe762d', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f7a0e39-ba36-4345-9630-7674398cd5ce', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04189c7b-2b6f-4a0e-81f3-d16bc38a0bb3', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e07577be-0245-4b73-93aa-409cff5626f8', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5a2f55c-6720-443f-8eb3-7553612da2a3', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28bbd288-e61e-487e-87e0-0b2347d97c38', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('120bdcfc-921b-4149-a4ce-fcceed6000aa', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3db6a0be-42d5-40a2-8880-c876db21180e', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('846ec598-8930-4162-9372-190963e962ae', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ec24c81-c116-4cb3-9f0d-343d3958a23b', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c3f84dbe-d4ed-449e-9043-b9a7d26f3104', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6704cd6-3c6c-40f3-b9a3-c35a5b059c53', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('144cc03f-0781-42b7-a970-307078136562', 'ef72fa4f-ac67-485c-95fc-f53878be7f9e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('147f863d-fe93-450c-9dd2-ff06f8362a89', '77fc649e-f888-4195-b57e-d56ab2b29c83', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 2nd November') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12212f31-639c-4fe1-8f53-fa221e09e504', '77fc649e-f888-4195-b57e-d56ab2b29c83', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'You applied to discharge condition 3. You are advised that this condition is a ''compliance') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9bf6f28c-c047-423f-af6f-5c02952ce3b5', '7f5e32be-3f8a-4ef1-9a1a-19de3011684b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b82723f8-a0d0-47db-bc97-52d01c485e30', '7f5e32be-3f8a-4ef1-9a1a-19de3011684b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd1e4c55-0f96-4ddd-9939-12a75d98ea23', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5777b8d-afe5-4a31-9889-16397dd18e07', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6427b7db-c780-45ae-8ed5-7ff043c2575a', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d42d5cd7-bee4-4ac9-98df-4b41fbdc837b', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('530daa45-cc69-4f67-9bc7-19aa7e7d64ed', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('70fbdbc8-6129-4ef1-8037-c816359b121d', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84cbc519-a353-4789-8f32-1190e4fa28e9', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1dc48aa6-2b29-451c-af65-fd2a7c8f69cd', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Technical Specification') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af2d398d-081a-4c93-aba4-6bc9af7df5c5', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2', 'other', 'Adhesive, basecoat and primer') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3094a5ac-703d-4868-acc6-85a0226d94fd', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.1', 'other', 'PermaRock Adhesive and PermaRock Lamella Adhesive are polymer modified cement-based') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c133792f-f821-4316-abda-5ebf5d31a358', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.2', 'other', 'PermaRock Bedding Mortar is a polymer modified cement-based powder, requiring only the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9e824ea9-56fa-4528-a291-5ebd3c55670b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.3', 'use', 'PermaRock K & R Primer is used for priming surfaces before application of acrylic/silicone K') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47a092b5-e0e5-4d39-84d4-e717ea45786a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.1', 'other', 'PermaRock Mineral Fibre insulation slabs are manufactured and supplied in accordance with') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01743bb2-65ba-4818-8f15-c8f2f5a18679', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.2', 'other', 'PermaRock EPS insulation is manufactured and supplied in accordance with BS EN 13163') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('588df181-8aa2-47bf-83b4-3156afec2db8', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.3', 'other', 'A summary of the information provided for each insulation material in terms of product') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b347274a-4fff-4843-8473-8bc32683932d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.1', 'other', 'Cement based decorative finishes:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8445e06-f4f7-4ac3-a0bd-052544ee8aab', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.2', 'other', 'Lime based decorative finish:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c0a9c05-dd51-485f-82af-77c017e3f5db', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.3', 'other', 'Cement-free decorative finishes:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('645ed2ff-2012-4b2e-a01e-afbcc7c74769', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.4', 'other', 'Brick slip decorative finish:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e454b45-4585-409a-b32e-eca9f8aca4c3', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.5', 'other', 'Fixing components for insulation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89b7e9ef-9718-4095-bf7f-93020e661808', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.6', 'other', 'Reinforcement materials') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1c978124-9877-4cc4-adc3-5059ce258bdb', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.7', 'other', 'Ancillary components (outside scope of the certificate)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('784c15e9-63fd-45ec-a3f9-3701801c56a7', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.3', 'other', 'Insulation and Render (reaction to fire)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48a61dac-32fa-40e7-9ebc-76b720004791', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.4', 'other', 'Fire spread on external walls') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a533829-4293-42ed-be2f-5f8d6965433c', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5', 'other', 'Other fire related construction detail requirements') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3253b55b-9d17-405c-86e9-00a5470cc903', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.1', 'other', 'All insulation types - As part of the fire performance requirements one fire resistant') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6224450d-8ffd-49a6-84db-29245271148f', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.2', 'other', 'Cavities - Where cavities are present, they shall be separated by horizontal and vertical fire') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('142e5a81-72b9-459c-a0ca-d9690427f5e2', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.1', 'other', 'PEWIRS will provide a weather resistant external wall insulation cladding to new and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d809a851-9709-4aeb-aa98-552c5ef96e17', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.2', 'other', 'For timber frame and light gauge steel frame the systems shall comply with the appropriate') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de849a6d-26af-4d6d-afa1-8b3344d47488', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5950', 'use', 'Structural use of steelwork in building respectively to ensure water penetration') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44322eb2-52d5-4b48-b118-48f54b9d3154', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.3', 'other', 'Where the wind driven rain exposure classification is very severe (refer to BS 5628-3 Code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bb7710e-5def-4735-9eec-8220e6f114a1', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2', 'other', 'Condensation Risk Assessment and Interstitial Condensation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df5cfc7f-6372-4073-a122-e21f682574b1', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.1', 'use', 'For PEWIRS used for dwellings the project designer shall determine the condensation risk') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5edfac5f-5c5f-42cf-bd07-1555c1c7c480', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.2', 'other', 'The condensation risk assessment shall be carried out in accordance with BS EN ISO 13788') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7e68bc3-1a35-41eb-984d-f812113db605', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3', 'other', 'Project specific condensation risk assessments are required for dwellings.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6091b9b1-930e-45d5-8ac1-a8a6625c1e34', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.1', 'other', 'Advice on construction detailing for thermal insulation materials is provided in BRE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('612a5a49-169c-4218-a4bd-c2b8d8d9129d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.2', 'other', 'Steel and timber framed construction shall be designed to avoid the accumulation of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad795ae4-a992-404d-a52f-f9a10ef8bf5d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.3', 'other', 'For steel and timber framed construction it is essential that any vapour control layer on the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2c279b9-7983-4c15-9617-a351ae70ca8e', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.1', 'other', 'The ultimate wind load to be resisted by the PermaRock Insulation and Render systems has') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('08255545-85a6-40b8-8c8a-83d876f149f2', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.2', 'other', 'The performance of the PermaRock Mineral Fibre system using the dynamic wind uplift test') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d220697b-8cb7-46eb-bf38-be44ccdc1e7c', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.2.1', 'other', 'The PEWIRS has adequate resistance to impact damage in situations other than those with') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52721840-75a5-4eb3-a1c3-1e764c13aa5a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6946', 'other', 'Building components and building elements. Thermal resistance and thermal transmittance.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('549730af-757f-4290-9f35-290e2d139fa8', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'U-value calculations, refer to BRE report BR 443 Conventions for U-value calculations') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e42f4b74-1745-4534-9259-da30449f849b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'External wall construction details (from outside to inside)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d38ad8e3-faee-4a14-925e-80afab20ddba', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Installation/Practical Application') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a2367b1-4721-45df-8d3e-a56d2d968e4b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Conditions of Certificate Issue') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd1862df-5a98-4d49-9a31-db033ceda691', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7b5a12f-28b5-4fb9-98d9-12fbeb28b63a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a4d26d35-f45e-438e-b851-23a1332a4f89', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ed427f58-3f6c-4b8a-9afb-337cb24075c1', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Substance or mixture classification') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a542441-3b87-4861-995b-c3c912855559', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Regulation (CE) 1272/2008 (CLP) and subsequent amendments and adjustments.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1cf964f-d17a-4006-b36c-0f11882c9bc6', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3d8e56d-2ae3-41bf-b158-41648603c7b3', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures (continued)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60b992d3-7d51-40f0-99d6-5d2ea8069b67', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'other', 'Most important symptoms and effects, both acute and delayed') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d0b2800-f6b1-4ba1-b254-3b6e8c5952a4', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'Indication of any immediate medical attention and special treatment needed') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01d0366a-e4eb-4e5a-b825-bdf943f7beb4', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'Special hazards arising from the substance or mixture') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ce5ed04-4371-4ad6-8607-da492c849faf', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Advise for firefighters') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84e0d344-8222-46bc-8e16-afa0afc951c0', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'other', 'Personal precautions, protective equipment and emergency procedures') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8af3691-18cf-4962-b6f9-26551aa9ef40', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.2', 'other', 'Environmental precautions') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8638ef55-bd11-4bd5-a390-479a7b686747', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.3', 'other', 'Methods and materials for the containment and the decontamination') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4c551c4-9a84-4cfd-9dee-7e59ecc21567', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.4', 'other', 'Reference to other sections') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a9daeb1-5844-493c-aa0e-8bb971ccb81f', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'Precautions for safe handling') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b37f04e0-a8b9-4027-a937-594958d76fe6', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.2', 'other', 'Conditions for safe storage, including any incompatibilities') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bff4150-ce72-4e24-85da-81c2af22fb98', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Information on basic physical and chemical properties') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19183fe6-1010-4972-9973-7fec610cf88f', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.3', 'other', 'Possibility of hazardous reactions') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ff9e737d-34b6-48cc-bbe6-33e752f28636', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.5', 'other', 'Incompatible materials') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3ae953e-91d7-4354-a2df-40544d3d35a2', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.6', 'other', 'Hazardous decomposition products') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f96bd93-4324-43ac-baef-17cb87945fe5', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'Information on toxicological effects') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d1d36c95-cfd2-4298-a18b-feba4a997ec7', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Persistency and degradability') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68515b64-e6e2-4e7b-9276-9cdf145bee64', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.3', 'other', 'Bio-accumulation potential') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a6eced4-0ca9-4b08-832a-9958cd7b348e', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.5', 'other', 'Results of the PBT and vPvB evaluation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d98ebf08-c10c-4ffe-ae76-5120023d52b0', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.6', 'other', 'Other adverse effects') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f30d62ac-5f7e-462a-a66b-1f9405b874f8', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'other', 'Waste treatment methods') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('327eb22f-fde3-48c8-870a-6c664902e447', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.2', 'other', 'ONU’s expedition name') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a24c24f-eb71-4f28-b1b5-bf0df0cec62c', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.3', 'other', 'Transport hazard class(es)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f30c1624-a92b-4592-8006-7a102c37e040', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.5', 'other', 'Environmental hazards') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5858e185-41af-4308-8532-c7bbf1e5923a', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.6', 'use', 'Special precautions for user') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c072ee8-bc5d-4eb4-a109-f84c42a4cebd', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.7', 'other', 'Transport in bulk according to Annex II of MARPOL 73/78 and the IBC Code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5848fdd1-2552-42f2-b92f-cc1043e54632', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Safety, health and environmental regulations/legislation specific for the substance or mixture') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc6ba34a-70ad-41dc-a29c-a41525abea0d', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'Evaluation of chemical safety') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('566a97fd-41d7-4e44-8e65-d6479a305e77', '9720e177-abee-4beb-a63b-7582113e42c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('974de5cb-41c5-4f4c-bfe2-374d6a87c530', '9720e177-abee-4beb-a63b-7582113e42c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7778e555-2d71-4360-b379-7f12636f9ea2', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0799476e-e2a0-43bb-8a19-fe563936940f', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('825a8c58-33b1-4b8c-ba37-74e334847ad4', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('634479e4-350d-4223-a646-7eac98b6af73', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('775ba182-8b4a-44bc-802b-f123dce823f5', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4624751c-972f-4868-8f3a-f987951bc836', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7c01dbb9-214a-4d74-a850-93a72f9e1cf9', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('147c4837-5241-4c42-8c1a-e0d6384ca567', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44a8ccb1-8bdf-4791-a44c-949adc4f4a0f', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d084cdce-5402-475b-be63-0c7fb4edce44', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c6921e5-306d-45a5-a1cb-c5263d4ec5c4', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b33d2401-6ce7-4502-89a3-230af8ac1a9e', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44e9e1cb-92ba-46b7-8b49-9ca33e65cbbc', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3afdf36e-990a-414d-bfb4-2c4c9befad31', 'd6fac437-f66f-4e1d-9720-036d9486538e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3cc137ef-f711-4f96-b096-e12f9157700b', 'af98801a-7091-473a-b16c-db393bd71200', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 2nd November') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('821d5c52-bec2-442e-818e-646b8e19dd95', 'af98801a-7091-473a-b16c-db393bd71200', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'You applied to discharge condition 3. You are advised that this condition is a ''compliance') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bac1627b-4426-49d7-a898-387986a5af0f', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Technical Specification') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a53590ca-8b23-42db-a880-fafbcaf61d90', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2', 'other', 'Adhesive, basecoat and primer') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('376b2a1c-0551-47c4-bbb0-01aee29f7237', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.1', 'other', 'PermaRock Adhesive and PermaRock Lamella Adhesive are polymer modified cement-based') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('901d8aae-3eec-4f23-aa09-7a3e5567c261', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.2', 'other', 'PermaRock Bedding Mortar is a polymer modified cement-based powder, requiring only the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('67ee5a6b-ef7b-472f-b960-41cc1f4ae8df', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.3', 'use', 'PermaRock K & R Primer is used for priming surfaces before application of acrylic/silicone K') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fe788eb-7bda-47ac-8427-b36d97ad2963', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.1', 'other', 'PermaRock Mineral Fibre insulation slabs are manufactured and supplied in accordance with') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12b8c1b0-cb29-4910-aa8e-3181b2b6d644', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.2', 'other', 'PermaRock EPS insulation is manufactured and supplied in accordance with BS EN 13163') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7fd5c33-a457-471f-b71f-e39a8e2f0f52', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.3', 'other', 'A summary of the information provided for each insulation material in terms of product') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c90a318-9f99-4049-aa54-beb255431a47', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.1', 'other', 'Cement based decorative finishes:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3668c76c-1df9-438d-9370-91cc8387d3fc', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.2', 'other', 'Lime based decorative finish:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6e6935b-c584-4722-aed6-6a6e59858069', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.3', 'other', 'Cement-free decorative finishes:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9bd3384-ff4a-4029-9a43-55323c79d844', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.4', 'other', 'Brick slip decorative finish:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa3ae970-658a-499d-be8d-353a8508728a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.5', 'other', 'Fixing components for insulation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7478dfb0-0714-41aa-b687-d0c51d527831', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.6', 'other', 'Reinforcement materials') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44a7572b-3738-4212-a153-4bcc686b3b56', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.7', 'other', 'Ancillary components (outside scope of the certificate)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2cdd948-00f9-4918-8329-7e7b60a9b253', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.3', 'other', 'Insulation and Render (reaction to fire)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c1d59a-8481-4c46-ad93-44d06e65fa76', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.4', 'other', 'Fire spread on external walls') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41bc962c-29e2-4708-af44-4642e24cf013', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5', 'other', 'Other fire related construction detail requirements') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd28e37a-da6d-4705-a8e0-cf81acbeae8e', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.1', 'other', 'All insulation types - As part of the fire performance requirements one fire resistant') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c42c9b-4a8b-4dd9-b897-1b047afd41b8', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.2', 'other', 'Cavities - Where cavities are present, they shall be separated by horizontal and vertical fire') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('450c35f1-cb04-4247-beeb-13e5c54300cc', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.1', 'other', 'PEWIRS will provide a weather resistant external wall insulation cladding to new and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00c44a7a-8ee6-4778-bf8e-56b41c84c8c0', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.2', 'other', 'For timber frame and light gauge steel frame the systems shall comply with the appropriate') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60827bfa-6db8-489a-a74f-8315a68bd49d', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5950', 'use', 'Structural use of steelwork in building respectively to ensure water penetration') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c74bf7aa-caa2-43df-b9ef-acbd6be19eb7', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.3', 'other', 'Where the wind driven rain exposure classification is very severe (refer to BS 5628-3 Code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8dd17b2-a425-478c-b22d-574aebe82f73', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2', 'other', 'Condensation Risk Assessment and Interstitial Condensation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a1858eb6-fa56-4d97-8692-15df5072fb5d', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.1', 'use', 'For PEWIRS used for dwellings the project designer shall determine the condensation risk') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49c15e02-cd27-4b92-af6d-986acdc7d207', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.2', 'other', 'The condensation risk assessment shall be carried out in accordance with BS EN ISO 13788') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('156072e2-8908-4978-bc98-a4192c23b45b', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3', 'other', 'Project specific condensation risk assessments are required for dwellings.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1d59f7e1-c136-4397-8f9f-7415cf3471f9', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.1', 'other', 'Advice on construction detailing for thermal insulation materials is provided in BRE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dabc42d9-4d42-453e-9ee7-2793df95f302', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.2', 'other', 'Steel and timber framed construction shall be designed to avoid the accumulation of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3bdf25f-8c2f-4788-b7cc-76c8836f6472', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.3', 'other', 'For steel and timber framed construction it is essential that any vapour control layer on the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b81384e0-ed9d-4687-96c7-3f87d186dd18', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.1', 'other', 'The ultimate wind load to be resisted by the PermaRock Insulation and Render systems has') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f0129fb-4cda-4f0f-a24c-efc97be956af', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.2', 'other', 'The performance of the PermaRock Mineral Fibre system using the dynamic wind uplift test') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82e2de71-4fc0-41c0-87d8-71faa65dca37', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.2.1', 'other', 'The PEWIRS has adequate resistance to impact damage in situations other than those with') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('580096fa-dc6d-4a2c-a7b9-54b32762fab2', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6946', 'other', 'Building components and building elements. Thermal resistance and thermal transmittance.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ace6726e-0ef8-4288-b379-7808383f5a3a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'U-value calculations, refer to BRE report BR 443 Conventions for U-value calculations') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c94e99f-dc47-4e38-baa2-52292a1c709c', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'External wall construction details (from outside to inside)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01441b4d-bc64-4bda-83c6-2a4efd62b0c9', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Installation/Practical Application') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99c21d50-b646-4790-bb6e-2625b88ce81a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Conditions of Certificate Issue') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c66f416-8862-484f-8009-022a2e63dcea', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a557f385-7613-4868-86eb-8e7de0e6a2ac', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83ecbe5e-ccd5-4e93-8961-9d9bc6a84335', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be9094a4-68fb-4233-85c7-ed83a12efbed', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Substance or mixture classification') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ebe449c-3983-4dc3-806c-dfd66ffeaf6a', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Regulation (CE) 1272/2008 (CLP) and subsequent amendments and adjustments.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28a8e1e8-7f2c-422f-87f3-794e73f47e57', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f44cc468-94cb-4454-a3f2-ed4ef9cbda66', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures (continued)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc089935-e160-4488-8c7b-0b4f9da314b7', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'other', 'Most important symptoms and effects, both acute and delayed') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb373206-a6e5-4154-9d54-51cd64cac1c1', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'Indication of any immediate medical attention and special treatment needed') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b759beb9-01f5-477f-a078-df629f7a25ea', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'Special hazards arising from the substance or mixture') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c20d085d-4d41-41aa-9283-a7d4b10b74cb', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Advise for firefighters') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('076acc1b-a6fa-42e8-ac84-3d3e0d869788', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'other', 'Personal precautions, protective equipment and emergency procedures') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d3dbc16-5b92-4730-8549-ad103a0eecea', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.2', 'other', 'Environmental precautions') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0820388-dee7-4049-ae07-b0d1a9f5e58d', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.3', 'other', 'Methods and materials for the containment and the decontamination') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('447c43d7-3723-457a-92b3-eef3ccd652b8', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.4', 'other', 'Reference to other sections') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3717fecf-61ac-4213-be93-18381739ab93', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'Precautions for safe handling') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('745b7edd-8b0c-4f85-8979-1b7550a6c11e', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.2', 'other', 'Conditions for safe storage, including any incompatibilities') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de42f038-6a49-49e7-8b32-bb73e7f27471', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Information on basic physical and chemical properties') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ebbdf464-7666-4607-b6fe-00787000b945', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.3', 'other', 'Possibility of hazardous reactions') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('249a2762-eb53-429d-ba5a-931ac3ffa4b8', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.5', 'other', 'Incompatible materials') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('17dc49d4-0f1d-42f7-9012-c3ce2365107f', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.6', 'other', 'Hazardous decomposition products') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6048f095-551e-48cb-a134-7517a4341886', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'Information on toxicological effects') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65ac0802-1e22-4756-b6aa-7fb3c8885c25', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Persistency and degradability') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c23dd16-4c22-4f38-8bf4-0f4ae97a40dc', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.3', 'other', 'Bio-accumulation potential') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd5114b0-299d-451d-8e10-3e810f63f589', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.5', 'other', 'Results of the PBT and vPvB evaluation') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8938dab9-cde3-4581-9990-915609a4f159', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.6', 'other', 'Other adverse effects') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5644d82c-3882-4582-8c3a-b5aa8ac5f3e2', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'other', 'Waste treatment methods') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('033ccfaf-2d84-4ca3-9cb4-6fb589db0878', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.2', 'other', 'ONU’s expedition name') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('43fb9a60-1ace-4eac-92cb-a094bf622835', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.3', 'other', 'Transport hazard class(es)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6b7562b-e236-4122-84ff-74307c0db0b5', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.5', 'other', 'Environmental hazards') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('802a7243-0a28-4c35-acfb-546133256a7d', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.6', 'use', 'Special precautions for user') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d07c0574-4c42-4320-ba9a-c6244f95e13c', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.7', 'other', 'Transport in bulk according to Annex II of MARPOL 73/78 and the IBC Code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81775498-249e-4df4-83ce-863b66b87b7a', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Safety, health and environmental regulations/legislation specific for the substance or mixture') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8a76e08-7022-4daf-8e24-ff0cef0d1ca9', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'Evaluation of chemical safety') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4479f696-6837-40c1-9b35-e83850924832', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('614a8952-578e-4936-859d-ddbe1d0736bb', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2742437-284b-4480-bc27-ec2b63ce95d3', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29def3cf-595b-4d80-87cd-50a6d677557e', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('199546da-42d1-4834-aa4d-df48a1ac1ee2', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8b8e155-4a01-41aa-b7b6-4943542fab39', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f61941c-f19d-41ef-a4c4-60ce57e1320b', 'd5e3467d-d0cd-41d9-8de6-b8366b925f85', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ff957c0-44a5-44c5-86d9-c47e0191d9bc', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3256fac6-c69d-40b2-9e98-8c90ded2f6ee', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('34b9b5fa-b036-4da5-9485-ffee66a8bf91', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4f97c5fb-13b4-423c-91b9-5c14f07b4c99', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1afc62bc-300b-46a0-907f-523c87dd4955', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bf64b4b1-1aea-4441-989f-7ebfd798bce7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('630268a8-d265-41ba-a549-ff6af98efda2', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('420b0e8f-1e7e-47e2-8b82-bb715865fc9f', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c04f88-f34d-44af-8ecf-9f120522fb94', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6848a5b3-3dd4-4c31-8bb2-f1b21f2ba749', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4d7c678-956a-4132-a059-48851021959c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d09d7189-50d7-4525-b1c6-8ac7419528da', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('017f40f5-12c8-4a8c-8aa3-b1b53d9b331d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9aaab1e-ea81-4987-aa06-fc4e108868a9', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e434890e-a20b-4af6-8dfa-e152b76b3ca5', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf83bd11-2ce0-45c9-9698-24c04a6a7841', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83d8e0a6-8e48-4d62-9548-a0483bd27810', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('811a1cb9-4cf5-4a89-8b53-913541d43089', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f85c7a0a-1d74-41dd-a057-ba11bf45cd20', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('502fcea6-ea6d-44f9-bac7-b5d02108d22a', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df0785d7-6262-47f0-9a60-ea64ecad9682', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe4e31b3-44fa-4246-933b-899284ab3471', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b726009a-9841-4079-ba00-767443a84566', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('217fb00f-d575-41c7-82f9-d6547606ac81', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c193d48f-8210-43a8-af41-e38ce8aa75e6', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('32e1844e-ece1-4e77-8e6a-1add50911cb8', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99fadb50-6ee0-4531-b7a7-15c6cf9e09ba', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2dec5ec8-b6a7-466a-baea-337cdbd4947d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4e3d9ff7-2790-4034-88c6-965ba8f72159', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21babbde-696b-4d89-8942-dca8ee059742', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5d1c92c-ed31-428e-8bb0-4f3ce3d5793b', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec574622-441f-4eab-b698-642d3b4a692d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eabf63ac-441a-4b99-a348-dfa027abbb21', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5ffc78f-ad2f-4988-9214-656459d5a451', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8dd8362-f629-4dc6-870d-7de30e1ffb07', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0fc42fc6-591b-4ed1-a1e2-1910990b463c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6fc831ce-80aa-4ca7-8949-c833c65fa1c8', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3594be86-abfd-4eae-b1fa-4295ffa24aa6', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce160e4b-56a5-44ee-9fff-57a8f445a07a', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47fb3046-2dd2-41e0-a7ad-cfaae3ded30c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4fa877c-0393-43e9-a68a-7b59506a09d7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb9993e4-95a5-40cf-b96f-f6453c2b4841', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc6e0a7e-73b7-4262-a286-7d9d1e48b322', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a74870c6-6c02-4cf8-8c8f-68ad86647b3f', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c8f46a0-f2c8-43a5-a407-ba173cf50148', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29d99378-b1da-4bc9-8565-0e7646c947d7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49137a91-d93e-4e7f-b8cf-828c52921868', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d66e88a-66de-4fbf-b04a-302853c76554', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e5fb1cf-d964-44db-9c0c-d78d6ed066ea', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c375619c-1fb4-49d3-9e44-5e628b3122d5', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80acb5b6-6644-4a24-96fa-e9740c4758c6', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('32c24ab3-c8f7-4b2c-a826-239740d3cce5', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d53f2ee-7646-41cd-8c96-a33f93151292', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ccca2c4-aefd-4d44-93c9-b1a9ad09e397', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e0b0676-2c60-4350-8daf-6bca68fa5b4e', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5661440f-7904-4f0d-8cd2-3e38b7dd0011', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b4e5364-0abf-464c-9184-7762b20673e9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de15d8b1-df08-43ff-b7df-0fc9f65e96f7', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('527fb857-d17d-4e1d-86a9-8e46be4f0afd', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b423f128-ff0b-42a2-8092-85db2ad3b09b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('320f4e5e-2d57-44c4-ae27-bcd5cf605972', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21dd2892-d4de-49d7-879c-8097709493d9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9144ee44-f5b2-4428-8349-0b58565d687c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cdb641dd-fe75-4f5d-a4a9-33f138b0247a', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e10a3de7-1e77-4311-94c6-56f4190b2894', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4dfd7c56-c16d-4b73-bd78-53ca4a255974', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0eb7b2e-162c-431e-9820-1e4c69f6ed49', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('88b4c706-9793-4587-85ec-de88441f8b18', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1978185b-4673-424a-8ce8-7a1a32868b70', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d26a9902-464d-425c-9587-095c14fe5531', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21ededea-6366-4ce7-bd79-6ae7770af04b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af878dfb-5668-4d61-a447-5b8b9a8b2dd9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b215db06-05c5-4a47-8df9-217115b488c8', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f443348f-f29a-4eb0-a343-bba922682f43', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cef79ae1-16ef-4697-a2d9-bfbbdd189929', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3dd861ec-ffc1-425b-9567-12919c825ebe', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96b8a2f1-7043-4632-b253-338b8b3ff332', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98be2d09-23e8-45c7-b42f-62601a5eccf6', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d620d71-6c22-4c34-88e0-bcd103b8136c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9da6f2c3-8b54-4c37-ae26-8a4849adcb40', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2887ddec-ff13-4963-b4a7-c0e8021b2154', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da64d774-e884-4054-8abd-ffc02ab1263c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d650a8f5-6f4d-47af-ba0a-8509173d035d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1dd84785-1ed1-4e47-826e-cabef766169e', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5ece361-12f4-4a3d-8cbb-5609ec114de7', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95f4d35-9db4-4f39-8e08-57815e626ca1', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b16c714e-a36a-4a3f-a712-1726c7cbb2fa', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82d95cbb-0a73-49a9-91fc-a5ed089c876d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd243ddf-7f4f-435e-81ba-eab510b05c31', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27aa1538-0ceb-4ad0-ab4f-b9f2458bf4a5', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ee8e8c6-33fa-45ac-a3a8-c194e267e2d0', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d858a4d4-99fb-42d1-bfab-fdd84262076b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae76a898-82b8-4221-8ef2-a4a0ba9c9600', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a0efb1a-3624-49fa-aa75-9f44a065040f', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1e8e5743-5778-4e48-961f-80ab93a1b397', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d62694d-8051-4d91-9a1f-4cd3cfd4f261', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27dfc1c3-fbb4-4d33-a15e-cc3f0f703e27', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('244c5ca3-2206-41d0-bedf-2c5c19375a0c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4550cbe-538c-4c26-9295-d1daa1cb90a1', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('910b5d95-e9cb-4bea-a0d2-dada3497470f', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3ddca7f8-b65d-4906-85fb-28c1f9a8c918', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5377e617-bfdc-40e5-9dc2-d455f8087702', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb259463-d45d-4fc9-893a-b576df5ba5f2', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c9ad3af-a45d-405b-965c-44cce4ac9f4d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa207a41-cea7-4005-9f10-e56daee1c4d4', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5e07459-d34f-4202-8f0b-98d66b8ab965', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe4f162a-bcdb-4b50-a490-ba6487f3a04a', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af1bc5ed-399f-4159-bbba-04fb9fdfb1d8', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b06a54b9-fd84-4239-b59f-85a241f59326', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a468ec69-8f58-4c64-be6b-eef8b6f9eb32', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27dd17cf-ea55-4376-81af-93634757fbcf', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c26aec40-236c-465b-9d4b-8e6c9a3abb4e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da6c635c-436d-40a5-9012-b249c759bf6c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0106f7d6-8409-4e19-9f49-d2b0b4c87553', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ed83e97-41a2-4fac-a76d-cb730dface1b', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9950d4ba-d580-428e-bbdf-ca64ebc1e380', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11ed4be-5733-4379-b983-33b0bcb676d4', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a178ce98-b801-4ea8-8330-5321e93ae574', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33064cdb-9077-4a14-95c7-bc9b8e36f0a8', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ff35c9a-797a-4723-8e98-74977f60e04c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('22641833-71ed-483b-871e-e91201bb231e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4859b2e0-b761-4f57-8e07-79767ee16a3e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80b0bae9-6e1b-4377-87b9-c5b538ddc615', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00a9414e-8c8d-470d-aea9-bd4fe3aaa6e2', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5056a4ae-c917-422d-a1e2-7685b2d49d7d', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('92089f64-ae9b-4c9c-a387-f6a4e1e5fc16', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0d72cbd8-d5e4-4d8a-b20e-816d683f0041', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c5c74df-e748-4c6c-8cff-347a31b99d06', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8d04663-d3c1-42a7-855f-1ddb1113d6df', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb542b67-5590-4cac-8d12-299daeccc97a', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d6f50aad-48af-457b-ae85-6dd5b1e4f689', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7ce47f39-491b-49b8-aac9-88564cd007e6', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89a0b827-d203-48d4-bfb3-34862c5e10e8', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99d76852-60ad-4d23-b2f0-97bb05c897f1', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd4ae95d-e80f-42ac-8eb4-564ecc35cf5c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a66b2bd6-93be-489e-96a3-7e52c8599f48', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c97f11c-b1c6-4234-90f0-457abfcf45c7', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b778fec0-1c8d-496c-b2f3-61d8ed562937', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4eeeb4db-625a-44fa-947f-670fea059a77', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79afeef2-7225-461b-9684-309f867c92b9', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be112a09-bce4-4e3b-b69f-ad8d78121d15', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31f80654-45ed-4ac3-a366-eab7bd6dcf71', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e679c81b-2fe8-4edd-9316-46bb276a3f52', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5f9f96b-b642-4a5e-9b27-d91bc1f98aed', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02b8474e-1747-4db9-9f30-31f50bdd2aef', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64bc8ce8-cc95-49bb-8b4d-af557a4c434b', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('027c1b8d-9730-4c62-89e0-80254f794875', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('23b21945-5ac3-4aa4-9ff7-ad067f2903f2', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e43d07db-177a-4ba5-87c1-d0233eca1253', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f01fcafc-afa6-4b34-8b32-6af21d81e21e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1544316e-26a0-43e4-9522-5027d02fe8f1', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e4f347f-3705-4ebb-9d0f-e26c3c656e6a', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1af1d9c7-301d-4d8f-ba2c-ee58c8ef0ddd', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dbc9169a-1387-41d7-9645-d010a73920da', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb960827-8e65-4309-b294-2c913c0fb8ef', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('335d0fa9-9071-4870-9ae8-a7b31dbcce5e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c5ccef0-0ba1-4364-883e-6a6c46296672', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('148fde85-7438-4b9b-b4a4-c9d2020b5309', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('452c01ca-1d4f-4b23-808a-a94323288115', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('07886075-e1fc-4362-ba64-6a5dbc336192', 'e1401690-ba1c-444b-9010-01d96ef1222f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '90274', 'other', 'Dated this 12 day of August 2024') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec2ebf94-91cd-4b2f-bf31-124bea34da2b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3eac9485-239c-4fe8-a0b3-dde64947eb54', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af462141-86d0-4914-8c2c-ebfde42bc592', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3626d752-86bd-418c-af69-48f5e5f617da', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dff634ed-91b9-4f9e-a780-be892085df59', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b4ad813b-8863-4470-8df8-90b4f5a56167', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a5771e21-b78a-4e96-9466-933b54737fa7', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fd8ffdfa-1bc5-4c57-9d98-6e02e1726177', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca9fb9f2-432c-4640-ac39-054819621168', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1e2829c-2edf-4583-89f1-eb5f0b3fc92a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3d70030-199c-4af8-87be-342da71c23ed', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04daeb79-32da-4c1f-8a73-64c2f3d4527d', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0dc14ae-3579-4f0a-9ba9-d2d33c0e6b34', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8497c284-27d5-42e3-871f-4ea6316dba9f', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfe42e57-36da-4c35-8486-c1177b3e3ee4', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86313aa3-1a87-44f3-9c8b-f8cebb1e41f3', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d66403e-ef56-48e2-a6f5-4b098836ff7a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55eb300e-cf19-48cb-afeb-5c771e31c59d', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('722a9167-5f61-4b42-a7be-7e7282c1daea', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6a5276f-265f-41e6-82f0-ffc9fdc65663', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66c0fcb9-c28b-4c4c-955e-29a80d1b1e75', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ae32b53-8611-4f8d-827b-6f16a02e7d4f', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef7c352c-2e66-4f4b-bef9-d738944e2fd5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e361ccb-e641-4f2f-aa3d-e1bd265a8085', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0add434b-b744-4cd1-bed2-3a5639ad6505', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59f73636-91aa-4709-b444-c7e7e18f8d0b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d0b09e85-ee78-4410-b265-a2ec269e60ae', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ece981d-d504-465b-b254-0802d481f328', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0461f3db-f24e-40b2-88ba-9c56ef7add68', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7eac3db0-c69d-4421-b577-1b0b11eff3b5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b94820d5-92ca-4184-9a9c-aeb6b09faac1', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a1d8c62d-8d38-421e-aec8-1c41795e0d62', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cd5a11cf-6a21-43c7-8984-d11809afb3a7', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('42f3314c-84fd-4bca-b3ce-6714a2dc6482', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('10f34660-65ba-47af-a80e-52ad5efd00b0', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f7d73c8-1ed3-4136-a9e2-3d1bf219a8a3', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ee86914-44bc-4eb7-89c4-050c49673564', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05830da5-8b76-4e2b-a738-9c5ca60868c8', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df46a4b3-ebfe-4a21-81e0-dadd2de451db', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('276e3ca9-7132-40d5-9717-659599389cbe', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('06041480-cba7-490a-b300-edcc4ae91aa9', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16e9f1ba-c361-436a-b717-3582acf3adf9', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29b39693-34a3-4aec-9636-68c70e1405d5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('85887368-6154-4b5d-9f0e-669670dc1d22', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8428744d-fbf7-4d51-a937-c14c90977f5b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3271ccf4-994a-464d-85f6-a70b8588cff5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de0c3ae4-0d39-4a66-ad01-fe216579df1e', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('413ba6fc-a176-4778-bd2f-bca964e64e3a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68f45d53-66fd-4f92-b227-27f343762a46', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b428e7f3-c570-48c9-afff-e1e8f0f44348', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2dec808a-7b82-46c0-9b91-dee1a0d6797d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44591ff6-f6e3-47bf-a027-1b4b234effa2', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e0bacaf-4a48-4a86-a3a4-d6a0bc15da22', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aab4370-85b9-448c-b457-e908fcf915c7', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52bcc6db-952e-404d-86d9-c5023da0873d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81a4981c-913e-44af-94bc-f37177c77f9c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec7f6dd2-3469-40ce-a469-7f331f58d47c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0f279875-510c-4d27-a81b-1431fbaaf3b7', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('984bf753-dea2-46ff-87eb-7916faf4ab99', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5989c068-ead5-4f3c-a16a-a28e476af3cb', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('781ee86d-7f51-4d7b-a2f9-7fe75b816247', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('840d63d8-c39c-458a-b9f5-2a29e015eab5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a147be8d-33de-4168-9176-93ed16cdfd72', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('94fab20c-41da-478c-aafa-e2ed49850f2d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0955c4c1-bbf0-437c-977f-0faf1caea5a5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02da1a8b-76ee-44c2-ae59-0ba01d726c5c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5984c246-b7b5-48ef-a68c-ca8186ce61a5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e224fbc7-65f8-47f7-89c6-a4b4fb7ea5de', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f7bb70b3-0600-4431-b2b6-341bd5db2f69', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('626eb7f1-ceb7-44ce-be6a-71edce2a7a6b', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa7ca497-ae0e-4bad-8539-a561041dc6a1', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('36ae0cf1-56e3-44ae-b18d-a10af6bed30e', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('53649717-cf0e-41be-b108-5373c29dc3da', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c85def6d-d1db-44ab-9652-f377f51f369a', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c2cf3c9-2a52-4992-b49b-a1ebbdc2a943', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
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
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98dd3fd0-b2f2-4117-a96f-b0cab8adc752', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef703f20-7644-4dcc-906a-f6ac6893ef08', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a7c0ba88-d553-4b32-b7b8-29da5191c044', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8fb0cc4-3396-4d94-9e53-c4372367c398', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f90a5d07-2fa7-48fc-a412-708ca36a2a69', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6ff94e98-d4f6-465a-adc1-e274e385b9b5', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('621c9bf8-6076-4924-8ebc-2409308a6a4b', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ad45757-8a67-45b4-8a7c-5690f2c2cbf6', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a3f8d116-bda1-4ef6-bac8-bdee906802b8', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25a84808-07e5-4e61-8d9d-7c45fe036e8c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f149ce03-b5ba-4493-a47e-64571beb6dcc', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ac4a9ee-cf29-4a4a-9c7b-8a3bd7a1e94d', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4868f33a-86b0-478d-9ce5-ffcb7d45a4b3', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c62ab4c4-9e21-4b4f-9b73-56c89d6a1d0f', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e11c1a90-79ba-4fe9-ac53-15f5c6ffdc67', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a98bca9-4903-46b6-ad93-6a1e18097058', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b53e963a-03d6-4f55-8817-27615a1f719c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c60fa8b8-f57b-4ee6-884a-fc566bdc8869', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de87888c-c8c3-4ce7-a872-9beea9fc8656', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d872265-a224-4548-ae90-0b644c5ea4cf', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05de1a2e-afdb-4a1b-a111-f36b8816a3a7', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45d19296-b485-4964-a3e4-1862d0f31e23', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a94a01e1-8892-49fb-ae61-90cbb53f0535', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f7bae0e-61ce-4ff4-b654-6b774e8c3931', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0e5d8dd-55ac-4650-a8d5-b1ac90869bf1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('94b23bb7-65a6-4c50-94ea-557751ba4ba3', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa002f6b-f949-4d58-ab44-8afcd10388cc', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('62f98839-9394-4e98-af42-c08df118ab11', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b7a9fcc-dfd7-4782-b50f-c0aff99cab7d', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8f524a6-d2b9-4ef7-b8b8-01086d7282fb', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01de0c02-4a3e-447f-923d-33fbe7d889e2', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fde64a5e-dfa0-408b-9446-5b2fe8c81912', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55e327f0-4c38-496c-82ba-90490ca7219c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2fd6e516-2fe8-4a38-b0c4-739cd1784ad9', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de9394ff-ad17-4e2f-81fa-0a99caaa9117', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b6a60d-e599-4de2-8885-ea9f0f5a18af', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('debb1e92-948e-4f20-b9b8-4c8673f4d24a', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ac1b6a7-da14-49cd-9a9d-72dc1d62ed69', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72919008-bcae-4ea8-a255-ebaea96d4975', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('beec6322-667e-4af0-8bee-f1a8930ebab6', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fff42d30-742b-4ee0-a2f6-dca89f1399e1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a53b5c10-3fd3-4d80-9894-08e0a914966a', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6950e3da-c264-4149-9d5f-aede14c6f1ff', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0446ac3-db51-4ea6-a102-d8d1b57799e1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2262176-3b77-46ed-afe8-f0e56e020a05', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ac2577a-80d8-44d3-b4fb-79e75d4617c2', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e32474f-f933-46a8-abfd-d7bd1c494f33', 'a3c2bc2d-fe6e-4a9b-93a4-dd893f81ae70', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2021', 'other', 'Building Regulation requirements in relation to fire safety') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f515e750-0b7b-40f5-b518-ca4a761f3922', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('626f72dd-47de-4e2a-ae58-b492634195f0', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb35df17-26b4-4e1c-833b-7827fbf661ab', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c333bc81-d059-4ee9-a7a7-46bbacb57e39', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd907b63-85fe-45b6-95ae-92e89169df41', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11e92aa-7324-48bd-ae39-7d9a910e32bf', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f6da22d-1839-45ac-afba-0e22a0abea38', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b160e38-f450-430c-8db7-5f4aa59c4abe', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0310220b-cd6f-4c3b-8abe-3780f8b51221', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bc218ad-1e0a-43f0-a487-fe5455b29e6c', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('695554d5-0091-4d3a-9a9a-bbfe9b7d64ae', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bdee88a9-9803-4c46-8fbc-850e2b52e54a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91895f4c-5e61-4fcc-968b-6c8fde02b2a1', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fe58d9a-f999-4cf4-b590-62ae79d01769', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cd2feca-023e-4b24-9523-ec90df2491ad', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('347ff972-943c-426d-a9b0-419be651da05', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84a4c255-05f6-482c-804d-be2d198ec2c7', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02c0fbd6-8cc5-4ef4-9c64-e30d1dd9bead', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1acd4cef-5557-4ed9-a286-b7ba3a2961bb', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72dabd1c-2b09-43a0-bdbc-4cfc2c3f1608', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5eb811b3-ed3c-4650-8a23-a4f33c1bbf17', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8dc5e86-5a2f-43b9-84fc-7ba9709ce213', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('023e966a-eb21-489a-bb72-72a38cbc4372', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9eab048-51af-4ed4-aa16-d4515ea04b9e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c54a51d2-b401-4028-a102-f54017cf45f9', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b56a607-9104-468e-a2f4-b4fb5caf980d', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b20c378a-b49d-4f46-8c29-a6a127b987f1', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4538b77d-744a-481d-a448-afddda209d70', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3c35f120-3f89-4ff4-9588-b4ca6dea24a7', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('13eabe8d-8ea0-411c-8434-3c14a309d0a3', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9e28e851-3995-41f1-a157-774b954b439d', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd6ad417-fee7-400a-8bec-f5d49a86204b', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5763adc9-d977-44a6-ab2e-84f94de3764f', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('97ab460a-543b-4dc9-bab1-da5bcb83146b', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1cc2c202-d9f5-4610-ba3d-647e881fd01e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a0f1ffc-6437-4a29-ba18-90543137a752', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7ca3784-78a7-4977-9bd9-e49cec6bf520', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3edd5fc9-498a-4116-9b18-e0a748cdb023', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cc319ce-c8e4-4db1-848b-e09bf70363e2', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da680ebd-8aa5-4389-ae6d-89881cda0a08', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f6a1f665-1e7c-4cd8-a692-86feaaec4831', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2fd6319c-bdb7-4adc-8146-b9a9df0ba667', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6540794e-6d5f-4971-905d-b59edcb2b44a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3adb0f93-1c88-492d-a07a-3ce02f7826b9', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27d00ad7-9907-4c15-b3b5-a8c3e7ff069e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e7c66d90-2646-472c-8a33-94de97a3ba9e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('942bcd60-f67a-47ff-8893-2722d8176e79', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca3e6767-0d70-4073-94f7-36ae91942a6a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6551a39c-3ac2-45d7-a43d-3029ab80de24', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('104e69a3-625e-4361-800c-e69104407c36', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('961f79a7-8f5f-4e2f-aa87-467a90640999', '4d69629c-f580-4503-8f00-3f6114a9e9ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'February 2017 (para (5)(e))') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3f52092-a869-4a57-98f7-f5c0ee248e97', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bdd6ee0e-a3f4-4d08-98b6-4185058bbaa1', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('681efb8a-5b35-4356-8491-b87440fb1be2', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a5e4391-ec60-48a8-9374-16e6f4fe2eb2', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a333aa4-5ce5-44fa-a124-e97d0beae3e4', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0432eefc-a5f5-4257-bbcd-f33ac8d27894', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3103dc4-ccba-40b8-9773-5b0408e13139', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e356331f-2380-4bcf-a190-660be9f5e919', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('58d222d4-fba5-421e-aad7-fd2988ff7574', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82af669e-3beb-4e59-9b40-c0866ef52f45', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26861ef9-c757-4051-841f-9e829643b487', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ddb3e7f-5838-4327-a2f0-974e46297330', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c59a7d13-1b84-43e5-a183-8a6a61f22473', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8036ad2b-4592-4072-a059-40bbc7d2892d', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ffdee59f-d6e8-4dd1-aac4-e58ec01308ea', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63f8caf8-46fe-4533-9d07-e7a06a529c09', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('95b7e999-cfda-4b46-8ae8-a23675afec56', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52e78aae-2537-490d-b826-874318809346', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf24e1f3-5de7-4b0e-8c38-f45cb18e2cf5', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3fd22aa0-edb6-401f-9ca9-4a7a49736a40', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e1dee3f5-36e6-4192-b94c-5eb8dd57e7c9', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb03a0f4-89c4-4d58-bfd4-1329f8fb8e1d', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e1a9fe3-f4a0-4b9e-8f0f-f106e510fa24', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb81df92-0715-4fe0-8912-078c89fbe6d5', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9593a953-13dd-4664-9453-3635b105c879', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b84b11b8-b189-44f9-8e7e-5101eb32bbb1', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28f12079-0e9e-40c3-b0b9-2c6560b17309', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('09cda3be-f90b-4bb4-84ce-6ee1c1c35da0', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f411b81c-727c-4b34-8c9b-1513c1ef9f19', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1bed745d-729f-4c26-a7b1-70392f1d3eb8', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('13fcc55d-b585-4f20-b549-727179e1b3a4', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00b6d9c1-d4ef-4e8b-805c-3b264bb0184b', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('114c5733-5c4a-4e0c-aa91-24635413e637', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5daf1653-dd60-43e8-a6ec-e2a0a26a44cd', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb7ec251-ea81-4291-8426-64bd7300482f', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b24f44e2-abc5-482b-a7e7-fc380fb7be35', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bd4f497-29dd-4ea2-9edc-3ed2ebfbf9eb', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26e6367c-be54-43ef-ac29-54dc08d5887b', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82adca84-86b9-4e9b-9be4-cdc58ade9107', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f04355c4-f5b2-4c32-ad2d-d2234ce051ee', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f67c4d4a-4f06-42ef-b71e-c99c8724df03', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b83ebf92-40f1-439d-8ca3-58a1af73491f', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c1d43c1-79fb-461b-9312-92bc1175bf90', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2f0a10c4-5083-4b72-b8ff-b30517935705', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18f46232-a30d-4e63-ba61-299024cbf25e', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6fc4a8f-2ac9-40e7-bded-415824eb5979', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ee9ec72d-0b32-46ee-864a-132d1cfb8047', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b44a8be-f01c-420d-80b8-ec0e16329761', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e83da94-6322-42ba-9198-13a0709002a3', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e614cbe3-fee5-47be-8f60-7d78481f3369', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5953fa62-7dea-4e62-a319-5951fad5d28d', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4cbf43ec-08ee-4aa7-a9e2-c00fd3ac9ac5', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52b98df7-1057-48ec-ad07-ec1b972d9943', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc7c2ab2-0a87-4ffb-9063-727b6f2da458', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5074037-cfb5-4f03-b65c-e1525fc06af1', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('07d9f3d7-33ab-4422-a438-396d1776e277', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16d96c51-44ae-4841-a173-ca6e795d76b4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad514cd8-a38f-4081-a8f8-e51df7eda686', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0d6462dc-fa7f-4dd3-b3a4-b96ba6b79edf', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('712d67b2-2ffd-4b7b-a2ea-f3b2f00ab5e0', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49de959f-4194-4801-bbe3-0fd11b381afa', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8993b8ce-ccb6-44ee-9d4a-240b4f5b1f35', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fa7b2af-8065-4847-a04d-c9a1c5a21da9', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66248836-acfb-4c5a-9da1-6d2c335e3e63', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('258a515a-2844-455e-bc22-9a7fc9cbda2c', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fcb73bf8-2a9f-4458-b2d9-ed9912e1794d', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('edd54221-976b-4848-bf27-8923774e2536', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0c9138e-3cf3-49ee-a426-4bf189c82779', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa2b25c7-d50d-4114-9245-cc6d328a8603', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c047a4d1-1841-4bb6-a036-f647d42e6b5e', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('62d202ab-9cd7-4e4d-bebc-298d69b3a780', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f65ca89f-9a7c-4a10-8367-32e2c2bda6a9', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0036da1c-b7c2-44da-847b-4aeb776f5816', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a51302a-9a99-4a6a-8b24-b6c9f250b1ae', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bcbb51b-2d38-46d1-8a14-afdf63126cf2', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0f0ae68-b00a-4ee8-91b8-ed5b06bfadc3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('381f6c77-52bf-4b41-a0ed-256f39f556b4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9ee2ae4-5717-4473-9c38-478d42156d17', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96592ab8-61a4-4249-ac3c-61e44bf462ce', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be0dff61-7cc1-4b69-8efb-f29f46ef24b0', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('652048a6-1b34-4364-acbe-eb733aef55f5', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f71cb130-5410-4b7b-a65d-1403f2a70a9a', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6570203-f186-4f25-9ecb-7662dabd5eba', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce06bc78-1e36-452f-8db0-88d44fb7c88d', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27cd95df-5f0b-408d-bcd6-9f21a128fea3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1e1b9ffb-977e-45b0-9ea7-7a0e33b758fb', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6ed16bf-65a6-490f-9d4d-e784f49b573e', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec6692ea-cd84-4e48-8fab-7017eac36988', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae165466-3e98-4ace-8cc5-83fafad51b31', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ad73684-f19d-47e7-86c0-f105c4671d7c', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e5f426a-f6c3-4af1-ac93-f08b4e6d6957', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba40bbe5-6fba-4907-a8b4-ab221ba34612', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72d902f8-d42c-4923-91e1-274bdec5e6f8', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('488bd817-3c0d-49d8-838d-bdf563055f36', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82e371fa-5970-4ea0-a8bd-affa3a7251ca', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('271d2fb4-6b94-4b0a-8ca9-5f696e0eeabf', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0fb4b144-0e94-427c-b60e-238c8b472ed3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f2a6bde9-29d9-48f7-8b66-76c742ec1874', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8425d3d7-ce99-466c-b41a-f61a3bfbdc79', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1581f6e-ff36-45e7-ac6d-905378ff07c4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7dc75351-3473-4383-9842-a38174b3c3d5', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a2351e0d-49ca-4df1-a02a-0f1d68bc7de4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('db79ee36-c629-428a-9b9b-c30a1d7d54fb', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f940e5a3-069b-4706-bd27-d5c359e81175', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dbe7872f-cb5f-49b8-8f51-e965f55d1645', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef35e7ec-dbc2-45f2-b18b-a647bcb24b83', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7c36b53-e59e-42e6-a367-513995a24274', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66d43b67-fdb5-4ec8-bc56-8a7a3149b87e', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f98f3e7a-2d07-4162-9cb3-b7f45c2c4c65', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8037b4b8-107a-42f0-9aad-af4e8575cfdc', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6fea3efc-7ade-4611-aad6-92e44e5e3e46', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bab2ec08-28f3-4c45-84ac-bb01923f8992', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3cd05b5-a39e-4d18-9001-bab7d153300d', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59157ba0-0f84-40e0-b521-67877848be6c', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0516f96-df40-4cb4-b7d3-8ec229022b74', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('686a8518-62e2-4a81-940a-72398247913c', '91cfec3b-9b4d-4ff5-a7c7-35b8e310c222', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'Office 210 Devonshire House, 582 Honeypot Lane, Stanmore, Middlesex HA7 1JS') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0772201b-80f2-42af-8390-14177ff70530', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'The Customer therefore hereby agrees not to deposit in any Equipment and/or place for') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04897800-a4ae-4cd6-a277-915e112836cc', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'The Customer shall have the care custody and control of the Equipment, whilst absolute title') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16909a29-950b-4e6b-b17b-e4a770c685dd', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.8', 'other', 'The Customer shall not, unless with Westminster’s prior written consent place any name,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('09c9f0c7-ac48-47af-95a6-edbcb58bce3b', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'repair', 'T he Agreement shall commence on the Effective Date and shall subject to early termination 8.1 The Customer shall at all times during the Term maintain with a reputable insurance company') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7cf34674-6bc1-4352-9ea9-0d0e334b4bd3', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8.2', 'other', 'The Customer shall, on demand from time to time, produce to Westminster such evidence of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('425d4fa7-6b51-47da-a19f-1ba536be7dec', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'insurance', 'Services rendered by Westminster insurance as may reasonably be required.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7b1c11b7-4cd4-4fd7-a158-02755a93e205', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'other', 'Westminster shall provide the Services during the Term in accordance with the terms of 8.3 If the Equipment or any part of the Equipment is lost or damaged such as to be incapable of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f814a877-aec2-41cc-9fc0-1bb21103324d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'The Customer shall place all Waste Material in the Equipment and shall not place any terminate this Agreement by giving at least 14 days’ written notice to the Customer.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('faffd49b-58cf-466b-bb9e-5331b8f2b511', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'use', 'In the event that the Customer places Waste Material outside the Equipment, Westminster amounts described in Clause 13.2(a) and (c) below; (ii) (ii) any deficiency between the full') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25dbe81e-d21e-46c4-a01e-24689a4d9b5d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'The Customer warrants that it has absolute title to the Waste Material and has the right to (iii) to make available for collection by Westminster any part of the Equipment not so lost or') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66426124-0cbf-456f-9506-49be56f41ed8', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'The Customer shall bear full responsibility for the identity of the Waste that is deposited in') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d73ca289-3cd7-419a-888a-f27f88261303', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Any changes to the type, size and amount of the Equipment, or the type or frequency of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa01a8bc-09f4-4133-893a-fd20ffa14b1a', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'The Customer undertakes that each Waste Transfer Note it completes in connection with') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('faa8a624-0b71-420e-bd90-0afa658f23de', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'The Customer shall ensure that prior to the Waste Material being placed in the Equipment Customer’s Location) within the area in which Westminster provides a collection service,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8119427-1cad-4cc9-8ced-c5b28182662d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Westminster shall acquire absolute title to the Waste Material when it is loaded into') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a9b5271-beb5-4d3a-aa1d-d2a31d183f92', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.1', 'other', 'The Customer shall ensure the Waste Transfer Note accurately records the Waste Material') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d4bc1fb-5e9b-4021-80a0-4adf63789edf', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Excluded Waste and Contamination') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6470047c-58ca-4092-9e53-a23ecf6f143e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'other', 'Unless the parties agree otherwise in writing in advance, the storage and collection of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a65c146-c3e3-4eba-9e13-c6597c125bac', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'The Customer shall pay on a monthly basis, or as otherwise agreed, for the services') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b1cb990-22e8-40f7-a46d-e6cb830a20b0', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.2', 'rent', 'Payments shall be made in full by the Customer to Westminster within 30 days of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('468bc180-f8de-4da8-b5ff-0abbd76ada48', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Rate Adjustments No amendments to this Agreement shall be binding unless in writing and signed by the duly') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6af09e7-c314-4512-826b-9106f8872fb9', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.1', 'other', 'Westminster shall have the right to adjust the published charges and rates to reflect authorised representative of Westminster and the Customer and expressed to be for the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('78161c34-73d8-453d-9ee9-10eb43358635', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Westminster shall have the right to increase such charges and rates, from time to time, 22 Waiver') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51b49f9e-4306-497f-b8e0-e27a4ab7cff1', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13', 'rent', 'Default in Payment and Termination In the event of any provision of this Agreement being or becoming ineffective or unenforceable,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3985d335-a4de-4a4d-a037-6c63c362ea73', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'rent', 'If the Customer shall be more than 30 days late in payment of the invoice as set out either in its entirety, or in part, this shall be without prejudice to the validity of, and shall not') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a02f3f5-2c45-418a-89e1-c20fb356fa83', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.2.1', 'use', 'If Westminster terminates this Agreement under Clause 13.1, the customer shall') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12cda72c-9c58-474d-a4b8-3e1a7e1b14b1', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.2.2', 'forfeiture', 'The Customer expressly acknowledges that in the event of termination of this This Agreement shall be governed by and construed in accordance with the laws of England;') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9346d626-bed9-49fe-a986-d68667a5785f', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'Liability 29 Dispute Resolution') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5c78e35-9de5-401a-84d6-a76c957de1ca', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Westminster shall not be liable to the Customer for any direct or indirect or consequential 29.1 If there is a dispute between the Customer and Westminster concerning the interpretation or') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a27d310-98cb-4a8f-8b9a-7b0409ed85d7', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '29.2', 'use', 'If any dispute is not resolved within 10 working days of the referral under clause 29.1 (or such') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc836dbd-4ea1-4b48-b1cb-2055b6daed5e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'The Customer acknowledges being subject to the duty of care under section 34 of the force from time to time. To initiate the mediation a party must give notice in writing (the “ADR') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('912a1774-40df-4bb5-b1e3-ec6321fddcde', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '16', 'other', 'Indemnity in relation to Equipment 29.3 If the dispute is not resolved within 10 working days of the mediation then the parties may refer') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('939d7786-bfb6-4932-9ca2-88441e1e337e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Indemnity in relation to acts, defaults and negligence of the Customer') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3b359f76-7ef4-42b1-8980-9375376aab64', '739e4e4a-51ab-4cda-8672-5fc40250ce23', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '511', 'other', 'Watford Road, Chiswell Green, St Albans, Hertfordshire, AL2 3DU') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e39cf1a4-5d1b-4783-8792-6e3ee51a4bf4', '0bd35236-6699-4c3b-b697-0c27db2c70f3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'repair', 'Months Preventative Maintenance of the Fire Alarm System at Pimlico Place, as detailed in 1 2,087.00 2,087.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('698845fc-0001-4b6e-9d89-64c6ca67269b', '96a5b44e-4bb8-400e-ae71-c7433a83a485', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '21', 'other', 'February 2020 Our Ref: 11043//') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb5865fb-784b-48ba-b4ee-db8fbd981498', '96a5b44e-4bb8-400e-ae71-c7433a83a485', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Stables Court, Orpington Kent BR5 3NL | www.fidelityintegrated.com') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('adf055f9-0276-4a27-ae45-0a6c75f02e49', '950254a8-5b7e-4462-9c79-e670aa5515f9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'repair', 'Six Monthly Fire Alarm Maintenance in line with BS5839: Pt1. per visit £240.00 £240.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c042d6a-fd11-4fa6-9cb4-304bf3b463d1', '950254a8-5b7e-4462-9c79-e670aa5515f9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Standard Man Hours - 1/2 Hour £29.00 £29.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb7f934c-2d49-443d-a212-d48dfa6dc061', 'a102285d-b8ee-40df-b6e2-0f317f40f809', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Generator Contract 2022-2023 0.00 0.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86ada4dc-2961-4140-83ca-7b8606a06391', 'a102285d-b8ee-40df-b6e2-0f317f40f809', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'repair', 'PowerCare Maintenance Contract - One Year Contract 795.00 795.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('57e6ab9b-af26-4667-8cd3-7d86b64a664b', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Employer (and/or plant owner) Network Homes') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('75f0ef44-6f22-4f61-81b4-15b3e9e89fbc', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Address NETWORK HOMES LTD') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('beca4511-33c7-44e3-84f2-9d08c703a19e', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Address at which the Corner lift') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('43aa37e1-98a3-451e-9e81-b96886c24904', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Description of Lifting ELECTRIC PASSENGER/GOODS LIFT (FIREMAN LIFT)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ac4895a-b7f8-454c-bd4a-4493f628fa01', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Nature of Examination Thorough Examination carried out within an interval of 6 months under Regulation 9(3)(a)(i) unless') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('50eb54b7-ab61-418f-92f5-1a02958b749c', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Identification of any part found None.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('461185f9-5210-485f-8a16-65fba7343d98', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'other', 'Observations and condition of Suspension belts are worn, but remain serviceable.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf6cf9ea-3855-4550-aa3c-95889355f8b7', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Date of last thorough 02/09/2020') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('76a26b29-f81d-458a-b5e4-21500f3ac030', '57bc2048-a53a-4ec8-b480-570613ac17b0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3566', 'other', 'Pimlico Place 21 Jun 2024 600.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d8141e9e-0cba-47fa-848f-c96d8bd31b64', '1fcc77fc-b84c-47d9-9300-1404944e2684', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Overspeed governor rope £460.00 £552.00 £3,312.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5ea8a43-181e-42b7-a361-27930fb1b28e', '1fcc77fc-b84c-47d9-9300-1404944e2684', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Counterweight overspeed governor £460.00 £552.00 £3,312.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d3006bd-19ca-44c2-b624-0a67d06384a0', '103cd843-5a84-426a-bfe4-6bd415838055', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'LIFT 2 BLOCK C - TECHNICAL £550.00 £110.00 £660.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4512ea1-4d88-4f80-a99d-4b527ca3aee8', 'e85eb392-86cc-4035-8b22-61f1dff9d500', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c235ce7-b014-4158-a721-4375c5b5fb0f', 'e85eb392-86cc-4035-8b22-61f1dff9d500', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('648169d9-ba04-40f8-9d33-1c2b2f7a0ef8', '9f2ff369-1493-4144-bfbf-61a2a346fb87', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99a1e6f3-5ab3-4d7e-a094-c7a0d19691b3', '9f2ff369-1493-4144-bfbf-61a2a346fb87', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('795b589f-2ab1-4f1f-905d-130dde699050', '47a74b03-ee8c-4d0c-ab70-b3f211f238b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96ce1704-fc15-4fc0-b525-4814defcee3e', '47a74b03-ee8c-4d0c-ab70-b3f211f238b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b670116c-c9e6-4d61-b3e9-a1190fc7ff64', '7b5597fb-9fc5-47ea-b103-990a2d32aa3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc403f18-2aaa-4e82-bfc9-1f3177ba9f14', '7b5597fb-9fc5-47ea-b103-990a2d32aa3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f5c56725-2d45-445f-a2b2-ac3e56bbcf7e', '71126a23-cffb-4eee-8799-42de128df70b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3eb72792-bd03-4759-966c-57b492aea633', '71126a23-cffb-4eee-8799-42de128df70b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e832f4e-aeab-4c60-8366-51a4ca74a6c1', 'bd0b6a9d-ef9b-4047-9c68-ef5b29969b33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ecd909c7-3330-464e-ac29-d1c63bc0045b', 'bd0b6a9d-ef9b-4047-9c68-ef5b29969b33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3f6e516-ede0-42cf-b4ca-b2f2d805466d', '7b6966c7-35c6-41a7-8fa0-5b5f0a5b15fe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dff0d080-2bfe-47ef-82f6-3bb8aa25ed1e', '7b6966c7-35c6-41a7-8fa0-5b5f0a5b15fe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6f9a297f-189f-4022-a4c7-32811e33fd9d', 'dc2ef695-862d-4276-98e9-5dda30a40512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16810a50-3f95-4af5-b0fb-867aecefb1c4', 'dc2ef695-862d-4276-98e9-5dda30a40512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9202b724-5f72-460f-987b-005823c853c4', '66bca7c2-124f-4756-883f-6bb12c5c4e76', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a2e697e3-a437-4834-a0f3-e64ecda4cdcd', '66bca7c2-124f-4756-883f-6bb12c5c4e76', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('97e03742-3336-4a61-9090-2d3b8d35b5ae', 'e5c753b5-ea5d-4d2a-9e28-9d778042c2d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b853b0d2-8b89-49a1-b2d7-0fa22bdcbceb', 'e5c753b5-ea5d-4d2a-9e28-9d778042c2d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f9c0bfd-29a4-40f5-a4fa-895deaa72173', '85eadd8e-4e1d-41a7-a55f-abfc68257ab8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18ef98f3-a5d1-4c8a-8a5f-86a9e3290588', '85eadd8e-4e1d-41a7-a55f-abfc68257ab8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fd1a5d66-c30f-4213-870e-90d812c346a4', '5c76bcb4-1977-4322-81df-029ec096aa39', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d8ba8a9-684c-4855-8d95-e7ac9dc8ce87', '5c76bcb4-1977-4322-81df-029ec096aa39', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f792311-6869-4b89-9ac2-2edbcd0a321f', 'fea1c428-5524-4406-a736-8e1d53088601', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('075ee039-1eff-4a01-9282-00dac39eaa53', 'fea1c428-5524-4406-a736-8e1d53088601', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ececa05-f705-4380-bc45-f3ab75e6fcc6', 'eaae6dfd-197e-4b0c-9bae-ebb868edae98', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b075d3ad-1500-405a-8fe5-980950222dd8', 'eaae6dfd-197e-4b0c-9bae-ebb868edae98', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('235892d5-8de5-461c-b61e-aa77262b5633', 'e83ba155-01ec-498f-ada9-7ece1b44627f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbd55b84-1584-4011-8b20-028cfd2a7350', 'e83ba155-01ec-498f-ada9-7ece1b44627f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('127d79a0-fcbf-441a-821f-c9566b2b5ff6', '7af48ec8-15a6-4f0a-a0f7-83d64067c563', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d651b978-20ef-4244-a314-fa1919537c0a', '7af48ec8-15a6-4f0a-a0f7-83d64067c563', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('181e9503-2496-4b60-ae41-029c52aa64c7', '5647d3ed-64dc-4ea6-8a2e-fcae520c07f7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2828d252-6cff-4cda-a1b6-bc6c8dd9b2e6', '5647d3ed-64dc-4ea6-8a2e-fcae520c07f7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c92edbcf-8592-4ec7-a27b-948e179ab433', 'b10696fd-e88e-454f-8257-1a5cb9d9d5ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e2a4cd6e-3f68-4dd7-804e-645488923ed4', 'b10696fd-e88e-454f-8257-1a5cb9d9d5ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f913cfcf-8904-4d51-af1a-9bf4b596be86', 'c0c832bb-d667-4de4-aabc-b2e4cde490a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('54002ca0-4e8a-4203-a8fc-bc5a6bce12b3', 'c0c832bb-d667-4de4-aabc-b2e4cde490a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0be1a9ea-ccbe-4ba1-8575-14d9811576e0', '5ac02cf1-7e76-4cec-b422-9d0da2387b67', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9cb3663-f0e6-46b6-8f08-73463dab52e5', '5ac02cf1-7e76-4cec-b422-9d0da2387b67', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c768fee-7b4b-4b29-a897-d3592d41fd54', '1ff2e680-718c-44fe-b6ec-6fab32335884', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2f974f2c-64c1-4c78-8680-1c86259e8b5b', '1ff2e680-718c-44fe-b6ec-6fab32335884', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f9909b2-d79c-4ab2-9eae-1026eb7c83a5', 'e7ad1749-12be-44cb-af83-4ac7a86c9527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7830624a-22ec-46a2-8e56-96c348246463', 'e7ad1749-12be-44cb-af83-4ac7a86c9527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a53f3705-fbf9-441b-bf01-11fb7b88a2ac', '559b594b-73a4-435e-b5a5-5c5874da40ee', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('021ee2fd-a899-4896-ac3f-35665072eeeb', '559b594b-73a4-435e-b5a5-5c5874da40ee', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d5dd5b5-bd33-4aba-81b9-74554485e73d', '1dc55017-87fd-45ab-838e-5b27a2f25d7d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f6bdc573-8930-4516-82f7-27e4cea5d84d', '1dc55017-87fd-45ab-838e-5b27a2f25d7d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d18bdc1-5a53-4323-bc04-334bf046c38d', '5db132b5-a467-4b41-9a18-4b4d29d02e5f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c27eb74-6a4e-4c2a-8a02-c130632b4359', '5db132b5-a467-4b41-9a18-4b4d29d02e5f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5df347fd-4131-4396-9d62-3f88a88f93b9', 'a9273119-4b21-49f7-b6ee-f8dc0e8bf015', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7dd18d64-94a7-4608-8bd7-f20bf858cbeb', 'a9273119-4b21-49f7-b6ee-f8dc0e8bf015', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e811d5e4-7f9e-4dd9-9030-5468c8f4276b', 'eee74efd-66d8-465b-b7a7-6d40316ac366', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55c16774-df02-4dfd-8168-fc17283b818d', 'eee74efd-66d8-465b-b7a7-6d40316ac366', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e7ce6df6-c880-48c4-9176-cd69515bb7d2', '85a4343b-5370-4608-a948-5d93e78cc83c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('95d8a04c-a501-4657-a107-fe5e8fa3161a', '85a4343b-5370-4608-a948-5d93e78cc83c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6b079057-40d2-4671-b3ac-f0c14197d20d', '07b7421a-6883-4ce7-96f5-077d988f8965', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('729a0ea0-2422-455a-bb08-1c900ec0b39a', '07b7421a-6883-4ce7-96f5-077d988f8965', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c7edaa22-9701-4e50-a85e-556a43af7078', '9100df52-72e2-4f05-9be1-d9e6eea9a639', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72e22638-aa55-4c8f-98d2-47130aa31d74', '9100df52-72e2-4f05-9be1-d9e6eea9a639', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3998b1f6-8ee2-4e7d-8da0-80faed86e604', '50597480-d627-42bb-97a6-e39156e58bed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c9fc13e9-18a1-45b1-9d67-d674a1d83eb9', '50597480-d627-42bb-97a6-e39156e58bed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd55b695-0085-4d26-ad22-8919377abfe5', '0e2491d8-e695-497b-a290-5048c15ffee0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9618443-fe4b-4244-838c-d3f15e422574', '0e2491d8-e695-497b-a290-5048c15ffee0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2ad8a57d-1b9b-4fca-8860-56a726c5ce49', '2cd37644-28ad-4f52-9733-75bc4cd3d953', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d9f6b0e-ff4a-4305-a200-a4c7c6b78cdc', '2cd37644-28ad-4f52-9733-75bc4cd3d953', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4f8e6c9c-613c-417e-9289-93db4de0d854', '9d51f8ed-229a-4e78-ab74-fff43005b9eb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25510552-4e7c-4fe2-8b42-922fcd6f57c2', '9d51f8ed-229a-4e78-ab74-fff43005b9eb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('62a25364-389f-4dd4-966e-8a4039c5981d', '3214f1a5-0066-4067-bf0e-8403f4e45d4f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9a60c199-730a-444f-9178-1516fd330037', '3214f1a5-0066-4067-bf0e-8403f4e45d4f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e3dc4f1-4397-4167-820f-ce8d6797a17e', '43abf0e3-5026-4fda-8651-4b2412756c6d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('17fb850f-885f-438c-9d33-a1ed9127a55c', '43abf0e3-5026-4fda-8651-4b2412756c6d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b4666851-ae94-4801-809b-64a4b91efd10', '75068077-df55-4c8d-97ac-c250d4061f73', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0271631-9166-4cf5-a68f-edb0e666d001', '75068077-df55-4c8d-97ac-c250d4061f73', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e637759c-c4b4-465e-927e-0076ee1881e0', '9d39cf2f-a383-4737-97d6-53d61a7038d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7df14ed1-c07f-4620-bc22-47325c6dc022', '9d39cf2f-a383-4737-97d6-53d61a7038d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d095a2af-1a7e-4d08-8e6d-e254f91d844f', '0c6d7808-a5a7-4508-8562-987b3cb8dc1c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7183b0a7-f4dd-4bb4-ba21-07e42551fd7c', '0c6d7808-a5a7-4508-8562-987b3cb8dc1c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('78f23226-f2b7-4790-8171-cec696ecddd2', '363c11a0-1ebf-467f-ae89-ade899c3d6c5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0773ac7-efba-455c-a633-4b87b951d6a5', '363c11a0-1ebf-467f-ae89-ade899c3d6c5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4097cd27-a3f3-4802-92a7-98ca6a57d8cb', 'a4de2c5d-0e64-49bc-bf13-2b8d2d0db59e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6b1590e0-fa61-4c66-a6ec-0b20ee864a20', 'a4de2c5d-0e64-49bc-bf13-2b8d2d0db59e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('868f88a6-bce3-4820-acec-f3b4e49ad907', '89c4dde1-19b5-4eff-958f-fcea75552bb3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6bbb3f76-348f-4b7d-bd96-22a5170bb92f', '89c4dde1-19b5-4eff-958f-fcea75552bb3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2ef420b5-dbe3-487e-850b-905a7e436cba', '91823810-463a-42e7-8f2d-c0878ea29371', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('36e04879-1f05-419c-959f-406500b17872', '91823810-463a-42e7-8f2d-c0878ea29371', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c716173b-52a0-4e0c-9fd2-45543fb41677', 'be9028a8-d104-4b47-bf1e-fcc0f3af4e92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b871996-893c-4425-9512-fd9a715eb926', 'be9028a8-d104-4b47-bf1e-fcc0f3af4e92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4974b4c4-79f9-4445-be67-fc2a02341c99', '2c7676a7-bcfa-45b1-a48f-6e5d410b7bfe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b9b163d-d648-4497-b3f6-f701dce3fcb5', '2c7676a7-bcfa-45b1-a48f-6e5d410b7bfe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1d665511-44e9-4409-b5d8-45ede0c5750e', '398553ca-b718-4c24-a284-c8478895b2ab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a98a4a9-9aa9-4b23-b548-c0d34fb4a9d7', '398553ca-b718-4c24-a284-c8478895b2ab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bda347b4-59f5-423e-a156-e78895ac7ac0', '53987e81-3ff8-495d-a8a2-e2828cb07fcc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a87cce4-b819-4574-a199-8952e4d45731', '53987e81-3ff8-495d-a8a2-e2828cb07fcc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d1521699-3512-45db-b432-287b38f4520a', 'e8680fc8-d791-417e-bcac-dc3d46172c52', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3246493-7817-4b98-9e8c-8c21b798e3a9', 'e8680fc8-d791-417e-bcac-dc3d46172c52', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8869c42-c039-4bc8-8fa3-87cbe5a6f36e', 'ea2d1dbf-4b97-4b21-bf7c-782899296743', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21e7473a-e804-4dca-a64e-5f1345272791', 'ea2d1dbf-4b97-4b21-bf7c-782899296743', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3d5f084-8fbf-4310-b9d0-68dc419e3eb3', '43468324-6bc0-4760-ab9a-5c11c4ac4ee4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('456fb3e6-0347-46f8-ab80-627b1abf9a5c', '43468324-6bc0-4760-ab9a-5c11c4ac4ee4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('624c7a50-4255-45ee-abcc-b609a5ec5b76', '5504dfa1-978e-4e5d-ba1d-154de0eb0b3e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0eab3b5-1e28-4ad3-b831-8d95c9a8fefa', '5504dfa1-978e-4e5d-ba1d-154de0eb0b3e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0893c9c0-62a9-45f9-afb8-ce18b1e6445a', '4008eedb-4522-4a64-af09-60267c2385e3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c4fa612-7b78-45a5-9bd0-e976136c7652', '4008eedb-4522-4a64-af09-60267c2385e3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca89346d-261e-4df3-af9e-d051c5552e25', 'ec24f634-6235-4e81-8747-83efca7710d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbbe9402-425c-40f8-be70-1f72157cc414', 'ec24f634-6235-4e81-8747-83efca7710d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0044f7a1-5679-4fc4-aaa0-6bc96abf1014', '55551d45-a273-418a-ab86-ce6943902ab6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60a25760-096c-42d3-a045-209cc5a397a3', '55551d45-a273-418a-ab86-ce6943902ab6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bcf0d02-3010-4937-9705-904954ec499a', 'd9f99bde-8214-43fb-9312-27daf39b8433', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('edabbc67-6cc6-4be4-845b-c30d71b69236', 'd9f99bde-8214-43fb-9312-27daf39b8433', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f89c5f99-7cbf-4391-9b4b-5fc6abc526a1', 'de941284-6853-48b5-9142-58674960fe82', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street¸ London, SW1V 1JJ') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4b24bec-df3f-4292-804c-74a20e77a951', 'de941284-6853-48b5-9142-58674960fe82', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Quarterly Service Serviced four times per year. 1') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('574ced9a-d60e-48c8-b34b-36fef3e24909', 'bb5d2dc6-58a8-4f2a-ba1c-06081b0086c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79f6f70b-94dd-4318-ba08-2f5746c8c30e', 'bb5d2dc6-58a8-4f2a-ba1c-06081b0086c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.00', 'other', 'We offer to send a specialist technical engineer to investigate lifts faults. £500.00 £500.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4dc7571a-a179-4bf6-bc7b-ac0ed5902a76', 'bb5d2dc6-58a8-4f2a-ba1c-06081b0086c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e855a3a4-bb87-4d07-ba41-dae91588b11c', '3370d90c-a949-4943-91de-17da09f848ab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6476b26-553d-4855-9f2a-6c668ab0da27', '3370d90c-a949-4943-91de-17da09f848ab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Deacon Trading Centre') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d6738460-8832-4d97-9e42-5e59d0352226', '6764a9d6-307b-4902-9561-81638962f404', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'GUILDHOUSE STREET PROGRAMME OF WORKS') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7f579217-67e8-4144-97b9-c4f44ad8ba7a', '73cfe506-dec3-4cb0-804f-2d270df17b32', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Churchill Court, Hortons Way, Westerham, Kent, TN16 1BT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1009f0e8-a24d-4947-937d-2a889f851887', 'fd9efcd5-72bb-4e89-a88c-20f519b42915', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Churchill Court, Hortons Way,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('438ecb92-2b2e-4a26-a1aa-3d0d48b55c04', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'use', 'St Thomas Street Site: Guildhouse Street (28)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29d13f6f-b9a5-457a-abe9-a2faedb7c72a', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Our proposal and your acceptance, is made and given on the express understanding that unless agreed otherwise in writing, the following conditions') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02aeb9c3-f4ae-42c0-a0f9-2cb30e1cd5d9', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.2', 'other', 'All proposals / estimates are made and given in good faith and although we exercise care as to their accuracy, we reserve the right to correct any errors') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('69fd984d-46aa-4c11-995f-726eb739d485', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'The extent of the work is limited to that shown in the proposal. Any variations or extra work will only be undertaken on your verbal or written') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8d0738b8-c5cb-4e2b-ab58-d12e12e814f6', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.4', 'use', 'Water Hygiene Management Ltd shall be under no liability for defective products caused by accident, misuse, neglect, wear and tear, improper') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('085a688c-5878-4838-a8ba-e48982feea7e', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Water Hygiene Management Ltd accept no liability for any 3rd party specifications or invitations to tender.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('261348d5-c5e0-4395-9bd7-251f9e233904', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'The fees in the proposal are based on the cost to us of materials and labour or in the cost of materials or transport above or below such rates and') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d882fd2b-e4e1-4985-80ca-99c93adc0e51', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'The prices included in the proposal / estimate and any order arising there from, shall be deemed to be based on circumstances ruling at the date of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3cac8544-b4cb-4323-803f-2ad8c579c686', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'covenant', 'If any law, order, regulation by law, tax or duty, etc, which affects the performance of our obligations under the contract is made or amended after') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('908239ba-6fb9-463b-9717-c4c5382f6646', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'rent', 'The price does not make any provision for Value Added Tax which will be invoiced in accordance with the applicable legislation and current rate.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0e1cbb4-0723-4324-9e09-d97b7f230413', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'All proposals are valid for 30 days from the date of initial issue unless withdrawn or otherwise stated within.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98dfcd4c-a31a-4dd6-80a0-dfb76b0b258c', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'alterations', 'Any alteration by the client in design quantities or specification or any suspension of work due to instructions will involve adjustments of the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('57969ab5-71d0-4338-9bca-3b9cf662eb00', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.7', 'rent', 'Priced estimates are NETT unless stated otherwise. Full payment is due against any raised invoice no later than 30 days NETT of the invoice date.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a6168581-1706-4e3a-b5b8-878b2f155359', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'other', 'All drawing, illustrations, etc, accompanying our proposal or contained in our catalogues, price list or advertisements must be regarded as approximate') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('85609c63-4c9e-4fbb-9eb5-df2dbd5e77a1', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'other', 'All weights, measurements, power, capacities and other particulars specified by us are stated in good faith as being approximately correct, but') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86ce4fa1-7f66-442e-af5e-0268b9595271', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'Any schematic diagrams are for illustration only and are not technical or factually correct.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5413fb30-88c9-41a4-b08c-34cb5fca71fc', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'rent', 'If no other terms of payment have been agreed, the terms will be nett cash 30 days from date of invoice. Where the contract calls for part payment') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80e086ec-de69-4dec-bf78-56463e672487', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'other', 'On over-due accounts (30 days) we will charge interest at the rate of 5% above National Westminster Bank Plc base rate from date of invoice. We') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6581b4f1-7bda-4eb8-b362-7d9af7987558', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'Should any deposit monies be required, all funds must be cleared to Water Hygiene Management Ltd prior to any works commencing on site. Water') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('75fdfa5a-02f9-4e44-a060-066b4442912e', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'If default is made by the Client on any sum due under any order, or if any distress or execution shall be levied upon the Client, the property or assets') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('779c2656-b5d6-4a1c-9359-719575126aac', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'use', 'Should our performance of the contract be hindered or delayed by your instructions or by reason of any act or omission of yours or by any cause') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f363a200-e347-45d1-b91a-444fb056fbee', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'Water Hygiene Management reserves the right to regard works as complete if we have attempted to book and complete contract works two times to') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2f2814cb-8840-4c03-8761-9888055892bc', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'use', 'We will use our best endeavours to complete the contract works by the agreed scheduled date, but will not accept liability whatsoever for failure to') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4de4385-2fc1-4f37-a112-bbc837a9fd6b', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.2', 'other', 'Should overtime working be requested by you or additional work or expenditure be incurred due to site conditions, we reserve the right to increase') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3fd2fa49-87d3-4e56-8be3-325731058217', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.3', 'other', 'Whilst all works are self-delivered, Water Hygiene Management Ltd reserves the right to sub-contract the fulfilment of any order or any part thereof') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d6afcb39-5e59-4466-8fe3-7a1adcbc94cb', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.4', 'other', 'All goods and services supplied and/ or installed at Customers premises remain the property of Water Hygiene Management Ltd until paid for in full.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5ac94d2-86f9-418b-959f-7d4a445b818a', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.5', 'other', 'Any addition charges including parking, congestion, ULEZ, tolls etc, incurred throughout the completion of jobs, due to unavailability on site, shall be') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('87f08564-cd4f-4da1-85b9-89c3202d5a50', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.6', 'other', 'Subject as hereinafter provided Water Hygiene Management Ltd will replace at its own costs all products which are or become faulty by reason only') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a78ad588-bae7-4086-aa85-2f44d77075cb', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.7', 'other', 'The times quoted for the supply and or installation of goods, or services, are to date from the acceptance of the order with Water Hygiene Management') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('273db15b-97d6-435f-8317-3f96e68bae88', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.8', 'other', 'Cancellation of project work, or services requiring material goods, will only be accepted on condition that any pre-ordered goods and time spent are') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6e722407-3180-40ef-9935-2a2aa7223654', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.9', 'other', 'If you need to cancel any appointment, we respectfully request at least 5 days’ notice. Any cancellation or reschedule made less than 72 hours will') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be15af1a-094e-4100-9138-004dc081a5e1', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.10', 'repair', 'As referenced in 5.2, There is no break clause within any contract works and once commenced will be fully chargeable. Maintenance works such as') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d85ff6bd-5ba7-434b-a5db-b188b50c373d', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.11', 'use', 'We assume the free use of power, water and client welfare facilities for the duration of a project or service for any Water Hygiene Management Ltd') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5d08b95f-43a7-495c-95ce-87e85d42406c', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.12', 'other', 'Under no circumstances shall Water Hygiene Management Ltd be liable for any loss or damage of any kind whatsoever to any property or person') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59999d6c-71c4-4538-a2cb-330d688301ad', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.13', 'other', 'Under no circumstances shall Water Hygiene Management Ltd be liable to for any costs arising for sourcing, administering, or carrying out any') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e2fb9d6-b05c-4984-94bb-bcff52c56ad3', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.14', 'use', 'Remedial Works: No acceptance of liability can be taken for any leaks caused directly or indirectly by our works.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c48c65c-9e56-4987-bec2-ffb14a5236d6', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.15', 'repair', 'Thermostatic Mixing Valves: are designed to be serviced and maintained, should any leaks/weeps arise as a result of these works we will endeavour') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c669190c-9fe0-42f2-ac4d-89d2ebd6b8aa', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.16', 'other', 'Closed Water Systems: we accept no liability for closed water system condition or causative effects of our recommended actions or dosing. Water') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2edaa97-67e1-44d1-b5ca-08dc8a77ed2a', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.17', 'other', 'If works we undertake involves drainage of water, we proceed on the understanding that all drainage facilities are mechanically sound and take the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ff38b68-3df6-40c2-804a-1e27639d07a4', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.18', 'other', 'All complaints arising regarding the product or services supplied by Water Hygiene Management Ltd must be made in writing no later than 7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51ae2d65-cf45-49dd-8057-14164e13fc43', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.19', 'use', 'No acceptance of liability can be taken for any airlocks caused directly or indirectly by our works.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b385eb1-4f18-4553-bfe7-5def1780bd29', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.20', 'other', 'Water Pumps: No acceptance of any liability for pumps can be taken. We accept no liability for faulty, old, airlocked or damaged pumps and the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4863ef93-9bf6-41ac-87ee-1eabbe473f83', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'Where you do not specify the chemical cleaning process you shall before commencement of the work afford us adequate inspection and sampling') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('794baf75-7107-4bca-ad8d-1d0991f83bcf', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.2', 'other', 'Water Hygiene Management Ltd shall be under no liability for any omissions in any technical reports or inspections. We will retrospectively amend') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a6683cf-68d9-489a-9d36-ff2b4c19813f', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'On acceptance of our proposal you will be required to submit any and all discharge notice at your own expense.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e99b301-2742-40ab-99bc-975242f2134c', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'All recommendations and advice given by us or our servants or agents to you or your servants or agents as to the mode of storing, applying or using') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c550216a-4706-434a-89f4-686f77786a24', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.2', 'use', 'In the event of damage to your property caused by our negligence, we shall make good such damage, the limit of our liability being £1,000,000 sterling') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b17b28c8-0be3-4501-8cc4-f1a81237d1ae', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.3', 'other', 'In the event that you shall specify the chemical cleaning process or we select the process on the basis of incorrect or inadequate information by you,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8507203-6774-479c-a90a-4035ec822757', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.4', 'use', 'We shall not be liable for any damage or loss caused by operation of any particular chemical cleaning process in carrying out the work if such damage') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f93dd0bd-5b95-47cf-bbcb-bf6cbd25ba1d', '75de85f1-8100-445b-bd6a-048896822857', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.5', 'other', 'Our professional indemnity limit is £1,000,000.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c243b48b-47e4-4705-95c9-8eec519ffc8b', 'f84ede1e-2577-448f-b9ba-65e57fd2a380', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Churchill Court, Hortons Way,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f8da366-26d7-49a7-b7bf-c5190b319fc3', '3c61cd14-7b1b-4da1-b3e9-ef40edbfb307', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Churchill Court, Hortons Way,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5beb829-4e55-4331-873e-f282cb68d73e', '7c0066c0-7b27-4668-96e5-a7a051bf394e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Churchill Court, Hortons Way, Westerham, Kent, TN16 1BT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('90b7e5ff-41dd-4bee-8782-ea5ebd5f7e4f', '4842a1c9-6e5a-42b3-9813-c3b0319f99b1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '711', 'other', 'Westcliffe Apartments') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d62d0f3f-13cf-4107-8eab-aff89836b237', '699c6866-7ecf-4728-8495-25b88bb2d99a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a1fcc2b6-440e-4ed6-8e56-b0735c9844e1', '699c6866-7ecf-4728-8495-25b88bb2d99a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51b9697b-7387-4cd8-b82c-9525b8adeb3b', 'b8a4f4bd-6f47-4c90-a8a5-b646828f7fe8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d1fd34d0-d1cd-4247-b43f-3bc2507b710c', 'b8a4f4bd-6f47-4c90-a8a5-b646828f7fe8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e64b891-87ad-46b7-97db-eacc5728ee23', 'bc0857cf-786a-4492-aea1-b444745f9d4d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7991b47f-bc6e-47be-8a6a-edbe33d6933c', 'bc0857cf-786a-4492-aea1-b444745f9d4d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9f06a0a-c9b8-47f0-8e6f-60d7ffeb2aab', '5ec5d99f-2cc0-477b-840c-bf5a068f8d26', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6196a92-1e48-4906-bcf4-a7c3964c0d22', '5ec5d99f-2cc0-477b-840c-bf5a068f8d26', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae482041-aa3e-4d1d-b99e-3a8410754575', '2e89900c-bc75-43af-8cff-c9a10fcba20e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b1518dc-1e68-48fb-92ef-5883782c910d', '2e89900c-bc75-43af-8cff-c9a10fcba20e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cd867d7-ec0c-4aa1-8652-fc05c0744263', '758b4843-863b-4964-b845-546edc17d373', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c1999bf-187a-4018-ba85-0ccbba8a4800', '758b4843-863b-4964-b845-546edc17d373', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c5db487-924f-4d4a-a637-5a8e39ca895f', 'e7721e58-2c1a-4844-99a2-0e484c9f1a97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('418ae147-9edc-48b8-9ade-391191c22d75', 'e7721e58-2c1a-4844-99a2-0e484c9f1a97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66a11e7e-9f05-4d34-aa59-a878cb075eb4', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'ST THOMAS STREET Quote No: 3197') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c3613e6a-1b95-4eb0-8d61-2e82b4b220f8', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY FIRE ALARM SERVICE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('149aefc5-3859-44fa-b7f5-97e491723397', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY DRY RISER SERVICE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb0041ec-339a-4b59-8253-961292549c42', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY FIRE ALARM SERVICE 2.00 £280.00 20% £560.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f24bf9e-1be8-47f7-81a2-6ff654af992b', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY AOV SERVICE 2.00 £375.00 20% £750.00') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('673d15dc-02a1-4fed-9de1-9affd8430f93', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb2b39c8-e581-407d-8a3c-4cc54a2a005f', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a42c5cfe-2c3f-409c-963c-dca8f5b17562', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79af0058-a9ef-4456-b4d9-402c00f2d995', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bcc6855-8ea9-4d8b-a314-4bcb7831ffd5', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('73da6bd2-376b-4537-a75c-2c5191f041c6', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2723b391-ab66-460c-bca0-f13aa03291a6', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e900d8d-5082-4c8e-96b3-e2a694d2c94c', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e68f57bd-444b-4552-b944-2778a41787e6', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25a60919-437d-46a1-b921-40c58671f602', '7e53d2b4-fbef-4041-bc78-839247ee8c21', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'London Bridge http://www.graingerplc.co.uk Newcastle upon Tyne, UK') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('14649d7d-6537-4f02-a883-8041138c365d', '61637eeb-d3c2-4f63-addd-8a6bde009eab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'use', 'Eastbourne Terrace			Merchant’s House') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9bb86e4-2909-4f0a-89bd-73c55a58b6a8', 'fd9b0d12-b87f-4923-88a1-8788d8e4cbff', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'use', 'Eastbourne Terrace Merchant’s House') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('88abb9a8-6536-448c-a6bb-67494346497b', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Employer (and/or plant owner) Network Homes') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bf8f6663-3172-4402-a938-56538bf9a9c4', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Address NETWORK HOMES LTD') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e47f034-8c68-46a3-99c8-4d93c274751a', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Address at which the E Block') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7b46c2f-c17e-4595-92d8-3cf35941124e', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Description of Lifting ELECTRIC PASSENGER/GOODS LIFT (FIREMAN LIFT)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b951b46b-9d38-48f7-b03f-d561d6d9bde6', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Nature of Examination Thorough Examination carried out within an interval of 6 months under Regulation 9(3)(a)(i) unless') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a5e8b7bb-c7e4-4cf1-aa64-09bd4b128e51', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Identification of any part found None.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('723af8cf-973b-48fc-b37e-ae3f3316578b', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'other', 'Observations and condition of The suspension belts are worn, but remain serviceable.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f2034f4-75ba-4632-bfa6-f9ed10a9ec34', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Date of last thorough 16/07/2020') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1debc94f-8ce2-40a4-98fa-cbae8dd0db65', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab24fbcf-7274-436a-afd0-7e2e93ba42e5', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3deca602-cfd1-4e61-bec4-72f7a13ead56', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a9c513fa-9aa9-4958-bc7e-7e1a4143f2ff', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Information about our regulatory status') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('572384cb-bec9-444f-ac17-2b647a250e19', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'insurance', 'Duty of Disclosure to Insurers') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ada920e5-01db-445d-a445-903af2225fc0', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10', 'other', 'Interest on Client Money') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af879dbb-803e-43f0-b998-d191605df948', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Cancellation of this Agreement') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74f55c98-2a56-460d-b5c4-fe5bf144c579', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'Prevention of Financial Crime') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('253aa0ff-b194-4540-9a2d-a9e1dd6b716e', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Limitation of Liabilities') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('14669e5d-a43a-41e9-a4e8-e4a34e0148eb', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('38c3dfd4-d954-4f48-bdf6-ea47613e3f0d', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce92673a-7ef0-4061-b93e-0716ca8b007c', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12e50850-24ee-4aa2-b16e-3ff1c99af534', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('794d2d4c-0553-4794-82fc-ba4c580cb1f8', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9736e0b9-c71e-4682-a150-db807b64fd36', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('078d7e43-25a8-498a-8e3f-6b848fb12916', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'insurance', 'Prevention of Financial Crime 21 Contact Addresses ST GILES INSURANCE& FINANCE') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0c2ae63-71d8-48c9-aa9e-353be4218436', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '16', 'other', 'Data Protection you. assets when it is responsible for them.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91cb304e-73f9-4166-8de7-d3a3019346fa', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Limitation of Liabilities Postal address These terms will remain in force and shall apply to will be aware of any possible conflict of interest.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d83a38c-15e5-4770-b67d-ee04e425fab9', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '18', 'use', 'Arbitration Wycliffe House the administration and performance of non- include the type of cover you seek together with the') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18b6a32f-ddf6-4a54-9b58-fce8baca0ec1', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'Law and Jurisdiction https://register.fca.org.uk/ or by contacting the FCA the progress of our negotiations.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('711f5bb7-cfc9-4b99-9eb5-f882ae86f47a', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'rent', 'Policy Documentation Where relevant we will remit claims payments to 8 Remuneration (Cont.) 12 Cancellation of this Agreement') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91a571b9-28aa-4893-940d-3bbc618676f1', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'insurance', 'Remuneration cancelled forthwith, or by insurers giving notice of') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0b68f1a-8b1a-4f12-a3ed-44708492a1be', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Claims premium that we collect from you on their behalf. All our remuneration is due at confirmation of order We are covered by the Financial Services') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0feb81e2-d703-463a-846f-360127ede927', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'CIEA]{ING & IIAI]ITENANCE STRATEGY') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ba49827-e72f-4f8b-b811-6c33e4a94752', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'other', 'FIRE STRATEGY DRAWIilGS') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e178329-8523-4aa1-9664-9e24a7552191', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'other', 'EXTERNAL ENVELOPE COMPR!SES') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad950b3c-759c-4848-ab70-05b05863d3b3', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.1', 'other', 'Polished blocks and stone banding at ground floor - self-cleaning. Any spray') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0f324e4-83f8-45cd-ad5a-08404b50bba3', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.2', 'other', 'Render at ground and first floor - self-cleaning. Any spray graffiti to be removed') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f6a7524-c93e-4189-8a79-b27855fe8670', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.4', 'other', 'Windows at first floor - tilt and turn, cleanable from inside.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ea4b2045-e512-45bc-9f5e-85e9339987a5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.5', 'other', 'Louvres at ground and first floor - self-cleaning and periodic cleaning. Any spray') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2ba644bc-e68a-4a26-bae8-e462f36016da', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.6', 'other', 'Access Ground floor: off pavement') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0281fb67-85b5-46eb-b624-234505006bc8', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1.2', 'other', 'Walls - concrete and fairfaced blockwork. Any spray graffiti to be removed by') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48778fa1-ce06-487f-a806-c63687a6b3c9', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1.4', 'other', 'Access via ladder - direct off floor for walls.') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b6d365d-f850-467e-9986-9e2f759e7b4b', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'assignment', 'STORE, SUBLETS AND STAFF ACCOMMODATION') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02e6e81b-c90d-477e-a0b8-aa55a40153d5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.3', 'other', 'SERVICE AREAS, PIPES ETC') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fa3f05a-91d0-41bb-aecd-0206a7eb4fb9', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'FIR.E STRATEGY STATEiIETIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('30d164e0-75be-4fd6-8974-789ef4160665', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The proposed development is a mixed use building on a site with frontages to Wilton') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64cb0369-9cce-48d0-8568-ee43472a0526', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Statutorv Con siderations') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d3b93083-8b7b-4adc-bd43-7a783e0571af', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'other', 'Compliance wath The Building Regulations 2000') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3621b36f-5ded-4ef7-bd9d-118241dc876a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'other', 'FIR.E STRATEGY DRAWIT{GS') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4f593ba8-0abc-4305-b373-d9ae4fc7fb3a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'I r ro e E lw & {t s B @ to - i t! - t c r * u d 8 , 6 6 S rrd I') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d697ea1c-4185-4a06-9e88-b79c8fa36992', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '0', 'other', 'MG (AMCC. Sl ) APRTL 1999') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d90ca2a3-4b51-4c8d-b3b0-1e67878bf229', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'KEY PLAN orfmr[tIArlrro. r') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a1d5af1-b1d6-4217-95b9-dadc54598364', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'E"-E''-tr''-T-''-''-- -''-') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fd52483-5e69-44dd-91d4-9810b2946599', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'KEY PLAN M N H m T r A a I& ,ll P') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9b6f217-d14c-4dbe-a081-5f9bda08b2d7', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'I 6,F --- w/c mru( r5') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb958a5b-1f32-4044-a1d9-c2376791d23f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'N r tr , \ ) t , r ) + 6 I o s{ r e s i lnc r c s t i l u t B l r u c rs l s8 t Y oucT l. s ''- f r,n !9d T ,l T s- {r^L strP! l[trd I t_ r g B r , c u f E U i E t $ l d t I 6 : q U E I I ( A '' E ER U @ E m qE (arcY S E -S c T EY AIfr l l - - l r L - a . l - P i ll9 - O(i -- E I tr ^ - - - - : - - S r G { E E E r o t . { u o * q t r s t t i t r E t f ^ o t f l i [ : h o 0 0 { o r @ 6 o t i $ x t a u t E i ,^ ( a v n t ^ l q t r m c u ( s r q l l r 6 A u tt c & u (s c s D r n r l a t do rFx') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52c87e13-ba11-455b-b115-4cfd9232ce48', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'POIId IO lrr Drrr ffi il J"r:. ,1''l , ,: . D 1 I sl o * l l') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51c2fb8f-4b6b-4293-b696-2de5eb8049dd', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '150', 'other', 'R(,: I Ltirl.l) AF''PIL ] !9Y') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e8a6974-e2ec-47cc-a0f8-5240f5acdf9b', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'EYTERI!AL''ilALL T]''PE!,') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a40dc9b4-736c-4871-8cd5-0ccea716f665', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.50', 'other', 'FG rLE(:)t.l ; irPPlL l9!r9') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa9d368a-1582-45fe-a547-4571cf98d2de', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'I ; :l: ",,,'' Etoil tnqr tnFTi wALt') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('505e53e2-3612-4c01-ac77-f552529e889f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '025', 'other', 'UNIT 024 uNfr 023 BRICI iAVII VIALL') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b9338343-30f0-4dc9-98ca-d22f085d5860', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'I - : RtilDtRtt ELOC| tAV|T! WALL') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1fb06df3-9455-48f7-9ea4-7e69e6a5ea67', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '150', 'other', 'Pa. /L[r ]l) APF IL I '']:I:i') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6899ebeb-900b-49d5-a33a-4e1b0b273c2f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '140', 'other', 'Ir r i lll t l E 1 , r , - lP ! Lltl l 9') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c73e53d-9ace-43d3-ad7f-bd07883dbaa5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Fll.{Lli r, ../LLA,.E t,t,.rtt.F,l.,jE|.lT" LTt)') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1922743-7fb7-4075-ada7-0883e65afdc7', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'M t r c tF t5 5 c t r ! L i t lo x a n F { c^totD aR! T ti c l . a u M r& t. R M s o rr tR F c s u Io r t e r ( s t . r 0 w r r c : 5 ilr r D ir rs -6 rr') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('386f950d-5dd3-409f-96e3-34b666be9a72', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7650', 'other', 'THI ILUSIVE CAIUEL I lr-------l') ON CONFLICT (id) DO NOTHING;
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e1294122-782e-4ba7-96da-aae0c229f29a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7650', 'other', 'THt ILUSIVE CAtvtEL r lr-------r') ON CONFLICT (id) DO NOTHING;

COMMIT;

COMMIT;