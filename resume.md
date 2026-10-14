# Tran Pham Hoang Duy

**Staff Software Engineer** · Mobile Infrastructure · AI-Native Engineering

Singapore · [LinkedIn](https://www.linkedin.com/in/tphduy/) · [tphduy@gmail.com](mailto:tphduy@gmail.com) · +84 383 330 246 · +65 8196 9978

## Summary

Staff Software Engineer with **10 years of experience** turning difficult problems into maintainable code—and occasionally discovering I wrote the difficult problem. My work has grown from **native Apple development** into architecture, performance, infrastructure, cross-platform systems, and now **AI-native engineering**.

Clean Code and Clean Architecture have been recurring concerns throughout that journey. To me, they start with **clear responsibilities and boundaries**. A simple MVC application can be clean; Protocol-Oriented Programming or Functional programming can fit a different problem. **There is no silver bullet.** I choose for the behavior, the team, and the delivery constraints, and question abstractions that make the next change more expensive. **Sometimes the best code is the code we never need to write**.

I want engineering decisions to start with **problems users and stakeholders actually face**. That means testing assumptions, discussing trade-offs, and letting teammates challenge and improve the approach. Delivery pressure is real; so is the cost of what we leave behind. I aim for choices the team understands, can maintain, and can adapt as we learn what works.

I design for **the next engineer and, increasingly, the next AI agent**. As agents read more of the code, I’m contemplating One-File Architecture and Context-Driven Development (CDD) against the Clean Code and Clean Architecture principles I’ve questioned and applied throughout my career. One file might be an agent’s highway—or a traffic jam with excellent visibility. There is no silver bullet; I’m exploring which trade-offs still hold when the reader changes.

## Experience

### OKX — Staff Software Engineer

**Performance Lab, Mobile Infrastructure** · Singapore · May 2025–Present

At OKX, my work grew from native application development into observability, shared systems, and AI-native delivery. I had spent years designing for the next engineer. Then the next engineer arrived as an agent, and “they’ll work out what I meant” became a less comfortable architectural decision.

- **Brought engineering principles into AI-native delivery.** Joined the SWAT team that delivered the agentic pipeline MVP between March and May 2026 and continued developing it after rollout. The production workflow spans shared Rust logic and native iOS and Android implementations. In owning its review stage, I applied clear responsibilities and separation of concerns through isolated review perspectives, configurable components, and structured findings kept separate from workflow decisions.

- **Balanced delivery speed with maintainable engineering.** Applied familiar engineering principles to an evolving AI-native workflow: explicit requirements, separation of concerns, and independently testable components. Created specs, tests, evals, and mocks to help humans and agents examine behavior and revise assumptions while delivery continued.

- **Owned the application-wide APM system and built development tooling.** Owned APM instrumentation, telemetry, monitoring, alerting, and production diagnosis. Built internal JavaScript MCP tooling and an early OKX trading alpha inside ChatGPT using OpenAI’s Apps SDK; the organization did not pursue the alpha further.

- **Received OKX’s Best Rookie 2025 award** after joining that year.

- **Applied architectural judgment at shared/native boundaries.** Supported Rust integration with native platforms and the pipeline enabling Rust development. Questioned which responsibilities were genuinely portable: moving an animation controller into shared code can replace a native boundary with platform conditionals. My focus was on boundaries that make sharing useful and maintenance understandable.

### Vestiaire Collective — Senior Software Engineer (iOS)

**Ho Chi Minh City, Vietnam** · Dec 2022–Mar 2025

At Vestiaire Collective, I learned that good engineering depends on how well people understand one another. Working from Vietnam with colleagues across countries and time zones pushed me to explain my reasoning, question my assumptions, and find approaches we could maintain together—even with a legacy application and launch deadlines to work around. That took patience, clear explanations, and a willingness to let others improve my ideas. Even “let’s have a quick chat” needed some planning when the other person had already gone home.

- **Contributed in an engineering culture built around open review.** Discussed proposals through RFCs and daily code reviews, where colleagues could challenge and improve an approach before we adopted it. Working across time zones made clear written communication part of the engineering work.

- **Led the iOS work to support new languages and markets.** Vestiaire’s custom localization approach extended from mobile through the APIs, departing from standard locale conventions and native platform behavior. Supporting each language meant reconciling those differences across formatting, settings, and external services. Established localization approaches and aligned product owners, designers, and mobile and backend engineers around them, driving the work toward industry standards while refactoring localization code and unifying formatters under launch deadlines.

- **Learned to look beyond the mobile implementation through the Zendesk integration.** Helped lead the work alongside the Android engineer, bringing together Zendesk’s sales engineers and our mobile and backend teams. Decisions depended on what the business needed, what the SDK supported, and how the pieces would behave together.

- **Shaped product decisions with A/B/C experiments.** My involvement grew from implementing changes to questioning what we should try and why. Contributed hypotheses alongside product owners and evaluated results, building a better understanding of customer journeys and the business trade-offs behind the work.

- **Improved existing features while contributing to the shared Design System.** Refactored features with SwiftUI within an Objective-C, Swift, and UIKit application, improving rendering, test coverage, and shared UI components. Supporting iOS 15 while newer SwiftUI capabilities required iOS 16 meant balancing product requirements with compatibility work and the technical debt it could leave behind.

### Tiki — Senior Software Engineer (iOS)

**Ho Chi Minh City, Vietnam** · Jan 2021–Dec 2022

At Tiki, the engineering practices I had begun developing at VinID became a stronger personal foundation. Clean Code, Clean Architecture, Agile, and Scrum became part of how I approached delivery, collaboration, and the responsibility that continued after release. I was fortunate to work with one of the best managers of my career, who taught me to own a product beyond its implementation. That meant understanding why a feature should exist, helping bring it into production, and following what happened afterward—with data to challenge the assumptions we had started with.

- **Led the iOS team rebuilding TikiNgon during COVID-19, when grocery access became an urgent human need.** Time-to-market was non-negotiable. People needed to buy fresh food during quarantine, and we needed to deliver as soon as possible. Our grounding in Clean Code and Clean Architecture shaped how we approached that pressure. We understood how a shortcut could save a day and make every change the following week harder. The challenge was choosing what needed structure immediately, what needed flexibility, and what could remain simple.

- **Adapted how we worked to protect delivery time.** During the rebuild, we used Kanban to organize the urgent work. Communication remained essential, but meetings competed with the time engineers needed to build. We kept interfaces aligned across teams while remaining willing to adjust them as implementation exposed practical constraints. Alignment was something we maintained throughout development, with room to revise what we had agreed.

- **Built interchangeable widgets with clear responsibilities.** The homepage, product detail page, and other screens could share the same widgets. Each widget represented a collection-view section conforming to a shared protocol: the parent controlled its lifecycle, while the widget managed its own data, preferred layout, and actions, delegating actions upward when needed. Using Airbnb’s [MagazineLayout](https://github.com/airbnb/MagazineLayout) for collection-view layout, we kept page composition generic while allowing each widget to handle its own behavior. Reuse came from a consistent contract that let a widget belong on more than one page.

- **Made production flexibility part of the design.** API responses and remote configuration controlled widget composition and behavior. When something needed adjusting after release, we could do more than disable a section—we could change supported behavior remotely, reducing the need for an application hotfix. We invested in that flexibility where it served a practical need, while keeping fixed behavior straightforward under YAGNI.

- **Decoupled navigation between modules through universal links.** This gave us flexibility in how experiences connected without tying navigation directly to another module’s implementation. Alongside reusable widgets, it helped us build around boundaries that could accommodate change. We balanced reuse and scalability with DRY and YAGNI, keeping fixed behavior simple where flexibility was unnecessary.

- **Learned to turn an idea into work we could deliver together.** I began scheduling discussions myself, bringing sketches, and working through proposals with designers and stakeholders. Taking initiative meant giving an idea enough shape for others to question it, improve it, and help bring it into production. Following that process widened my understanding of engineering: the work included building shared understanding and carrying a proposal through the decisions needed to release it.

- **Applied Middleware to the processing behind the “Buy” button.** A single action could trigger different combinations of steps depending on the product: some sequential, some parallel, and some dependent on earlier results. I adapted an approach familiar in Node.js and server-side development to model those relationships on mobile. Middleware was the central architectural idea within the broader Buy-button work, and a concrete example of choosing a pattern for the behavior it needed to represent.

- **Developed the habit of following features after release.** Analytics, production operations, and continuous improvement became part of my understanding of ownership. Proposed ideas, tested changes with smaller user cohorts, and used results to guide wider rollout. I learned to ask whether a feature was doing what we expected, what needed to change, and whether it still deserved continued investment. The same responsibility that brought a feature into production included recognizing when it was time to retire it.

- **Strengthened Agile and Scrum practice in a team that organized its own work.** We operated without a dedicated Scrum Master, learning to take initiative and share responsibility for how we worked together. This reinforced the connection between individual ownership and team delivery: bringing an idea forward also meant helping the team discuss, plan, and carry it through.

### VinID — iOS Engineer

**Ho Chi Minh City, Vietnam** · Feb 2019–Jan 2021

I feel lucky to have joined VinID when I did. Vingroup was investing heavily in technology and bringing together experienced engineers, and I was among the early members of that journey. I had studied architectural principles before, but this was my first opportunity to practice them with a team working to high engineering standards. It was where the engineering practices I had read about became habits I could develop with others, and where I first practiced Agile and Scrum. From Uber RIBs and reactive data flow to release cycles, estimation, and retrospectives, each new responsibility widened my understanding of the work—and of the care needed when many engineers are building the same application.

- **Put architectural principles into production practice with Uber RIBs.** Applied Clean Code and Clean Architecture while developing features and reusable components, learning how responsibilities and boundaries held up as the application evolved.

- **Learned to develop and release alongside 30+ engineers in a shared repository.** Practiced Conventional Commits and saw the value of a clean, traceable Git history. Git flow introduced me to release candidates and hotfixes, and how multiple features and bug fixes could progress in parallel through a shared release cycle.

- **Began practicing Agile and Scrum in production development.** Worked with story points, estimation, and retrospectives, learning how a team plans shared work, discusses uncertainty, and adjusts its approach as it learns.

- **Worked with database-driven, reactive development within Uber RIBs.** Fetched API data into a local database, with Interactors observing changes and updating presentation through reactive streams. Worked through memory and persistent caching, stale data, database responsibilities across RIBs modules, and local migrations—alongside concurrency, locking, and data-race problems.

- **Designed reusable, generic components around team standards.** Learned to consider how a component would be shared and maintained beyond its original feature, balancing flexibility with clear responsibilities.

- **Implemented Bazel to improve build times.** Reduced compilation time from approximately 12 minutes to 5 minutes on the Intel MacBooks used at the time.

### VNG Corporation — Junior Software Engineer (iOS)

**Ho Chi Minh City, Vietnam** · Mar 2018–Feb 2019

VNG was an early chapter in building the native iOS foundation I would carry into later roles. My university did not teach mobile programming, so I was learning it independently—with a large legacy application providing exercises nobody would voluntarily put in a textbook. I already believed in Clean Code; architecture was still mostly theory. The Objective-C- and C-heavy codebase gave me a practical education in what happens when programming discipline slips. I felt lucky to have my potential recognized and to receive opportunities to learn through real work.

- **Built my first foundation in optimization, from code to user experience.** Working with the large application on a struggling Mac mini made performance difficult to ignore. I learned how falling frame rates could turn scrolling into a frustrating experience, and worked to improve it instead of letting hardware limitations end the investigation. The Mac mini had a convincing defense; I still had code to examine.

- **Learned to work around tooling constraints.** Storyboards added another challenge to an already demanding development setup. I learned to build without them and gained valuable experience in the process. I later bought my own base-model MacBook Pro. There were cheaper ways to learn iOS, but I had already tried one.

- **Maintained and developed features in a mixed Objective-C and Swift application.** Working through tangled responsibilities made the cost of missing discipline concrete and gave practical weight to the Clean Code principles I had been studying.

- **Optimized scrolling for large, complex lists and built customizable UI components**, connecting implementation choices with how the application felt to use.

- **Expanded my experience beyond individual screens.** Implemented HLS video streaming, improved internal networking frameworks, handled local and remote notifications, and built a news-focused iMessage extension.

### ExecutionLab — iOS Engineer

**Part-time** · Ho Chi Minh · Jul 2016–Jul 2017

I started learning Swift because I found it elegant. That curiosity brought me to ExecutionLab, where I began working part-time in 2016. There were experienced backend and frontend engineers around me, but I was teaching myself iOS development. I wanted to write elegant code. First, I needed something to appear in a table view.

Making an HTTP request, receiving a response, and getting the data onto the screen took hours of study and effort. Today, that can start with one prompt. Back then, it was quite enough to keep me occupied. Gradually, I connected those pieces, built features, and developed my foundation in iOS.

Years later, I help build agentic engineering workflows where AI can generate the implementations I once struggled through. My younger self would have welcomed the help. My present self draws on those struggles to define requirements, question generated code, and judge whether an implementation does what we need. Learning to build those small things gave me the understanding to take responsibility for larger ones.

Swift has been my friend throughout that journey. What first attracted me to the language also became something I value in my own work: elegance in the code I write. That preference now shapes how I build with AI, too—seeking clear responsibilities and code the next engineer or agent can understand.
